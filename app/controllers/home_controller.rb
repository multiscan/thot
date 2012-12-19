class HomeController < ApplicationController
  def index
  end

  def admin
    authorize! :manage, User
  end
end
