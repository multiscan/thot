class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_gon_for_admin

  # check_authorization

  # override CanCan's default as it is only ment to for with current_user
  def current_ability
    @current_ability ||= case
                         when defined? current_admin && current_admin
                           Abilities::AdminAbility.new(current_admin)
                         when defined? current_user  && current_user
                           Abilities::UserAbility.new(current_user)
                         when defined? nebis_user && nebis_user
                           Abilities::NebisAbility.new(nebis_user)
                         else
                           Abilities::Ability.new
                         end
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  # rescue_from User::NotAuthorized, :with => :user_not_authorized

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
    gon.nebis = @user.nebis
    gon.nebis_extend_url = nebis_extend_url(:json)
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

  def user_not_authorized(p=root_path)
    flash[:error] = "You don't have access to this section."
    redirect_back_or_default(p)
  end

  def set_gon_for_admin
    gon.admin = admin_signed_in?
    true
  end
end
