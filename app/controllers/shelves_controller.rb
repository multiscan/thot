class ShelvesController < ApplicationController

  def index
    if params[:location_id]
      @location = Location.find(params[:location_id])
      @shelves = @location.shelves
    else
      @shelves = Shelf.all
    end
    respond_to do |format|
      format.pdf
      format.html # show.html.erb
      format.json { render json: @search }
    end
  end

  def show
    @shelf = Shelf.find(params[:id], :include => "items")
    @items = @shelf.items.paginate(:page=>params[:page], :per_page => 50)
  end
end
