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
    @item = Item.find(params[:id])
    @book = @item.book
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item }
    end
  end

  # GET /shelf/:shelf_id/items
  def index
    if id=params["shelf_id"]
      @shelf = Shelf.find(id)
      @items = Item.where(shelf_id: id).includes(:inventoriable).sort do |a,b|
        if a.inventoriable.is_a?(Book)
          ai=a.inventoriable
          bi=b.inventoriable
          [ai.call1, ai.call2.to_f, ai.call3, ai.call4] <=> [bi.call1, bi.call2.to_f, bi.call3, bi.call4]
        else
          a.id <=> b.id
        end
      end
    elsif id=prams["location_id"]
      @room = Location.find(id)
      @items = Item.where(location_id: id)
    elsif id=params["lab_id"]
      @lab = Lab.find(id)
      @items = Item.where(lab_id: id)
    else
      @items = Item.order("created_at DESC").includes(:book).paginate(:page=>params[:page], :per_page=>50)
    end
    respond_to do |format|
      format.html
      format.pdf
    end
  end

end
