class AdmController < ApplicationController
  before_action :authenticate_admin!

  def administrator_only!
    # raise User::NotAuthorized unless current_user.admin?
    if current_admin.admin?
      true
    else
      user_not_authorized
      false
    end
  end

end
