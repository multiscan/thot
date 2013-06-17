class AdmController < ApplicationController
  before_filter :authenticate_admin!
  before_filter :set_gon_for_admin

  def administrator_only!
    # raise User::NotAuthorized unless current_user.admin?
    if current_admin.admin?
      true
    else
      user_not_authorized
      false
    end
  end

  def set_gon_for_admin
    gon.admin = true
  end
end
