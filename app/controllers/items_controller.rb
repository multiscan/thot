class ItemsController < ApplicationController
  # # GET /items
  # # GET /items.json
  # def index
  #   # @items = Item.all

  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.json { render json: @items }
  #   end
  # end

  # GET /items/1
  # GET /items/1.json
  def show
    @book = @item.book
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item }
    end
  end

end
