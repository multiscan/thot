class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  # rescue_from User::NotAuthorized, :with => :user_not_authorized

  def administrator_only!
    # raise User::NotAuthorized unless current_user.admin?
    if current_user.admin?
      true
    else
      user_not_authorized
      false
    end
  end

  def redirect_back_or_default(default, *options)
    tag_options = {}
    options.first.each { |k,v| tag_options[k] = v } unless options.empty?
    redirect_to (request.referer.present? ? :back : default), tag_options
  end

  def redirect_back_or_root(*options)
    redirect_back_or_default(root_path, options)
  end

  def nebis_user_login(user)
    @nebis_user = user
    @nebis_uid  = user.id
    session[:nebis_uid] = @nebis_uid
    nebis_extend
  end

  # setup variables needed for nebis session. Return true if session is valid
  def nebis_session
    if nebis_uid.nil?
      return false
    else
      @nebis_expire = session[:nebis_expire] || Time.new(0)
      if Time.zone.now < @nebis_expire
        nebis_extend
        return true
      else
        session[:nebis_uid] = nil
        return false
      end
    end
  end

  def nebis_user
    @nebis_user ||= nebis_session ? User.find(nebis_uid) : nil
  end

 private

  def nebis_uid
    @nebis_uid ||= session[:nebis_uid]
  end

  def nebis_extend
    @nebis_expire = Time.zone.now + ENV["NEBIS_LOGOUT_AFTER"].to_i
    session[:nebis_expire] = @nebis_expire
  end

  def user_not_authorized
    flash[:error] = "You don't have access to this section."
    redirect_back_or_default
  end

end
