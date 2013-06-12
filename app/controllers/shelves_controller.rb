class ShelvesController < ApplicationController
  def show
    @shelf = Shelf.find(params[:id], :include => "items")
    @items = @shelf.items.paginate(:page=>params[:page], :per_page => 50)
  end
end
