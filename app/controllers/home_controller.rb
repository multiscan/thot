class HomeController < ApplicationController
  def index
  end

  def stats
    @labs = Lab.find :all
    @items_by_lab = Item.count_by_lab
    @items_by_status = Item.count_by_status
    @books_total = Book.count(:all)
  end

  def admin
    authorize! :manage, User
  end
end
