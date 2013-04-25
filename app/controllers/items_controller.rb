class ItemsController < ApplicationController
  # before_filter :authenticate_user!, :only => [:new, :edit, :create, :update, :destroy]
  load_resource
  # authorize_resource
  before_filter :set_and_authorize_book, :only => [:new, :create]

  # GET /items
  # GET /items.json
  def index
    @items = Item.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @items }
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item }
    end
  end

  # GET /book/:book_id/items/new
  # GET /book/:book_id/items/new.json
  def new
    @item = @book.items.new
    # TODO: only list labs and locations that are manageable by this user.
    @labs = Lab.order('nick ASC').all
    @locations = Location.order('name ASC').all
    @currencies = ENV['CURRENCIES'].split
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
  end

  # POST /book/:book_id/items
  # POST /book/:book_id//items.json
  def create
    @book = Book.find(params[:book_id])
    if @book
      @item = @book.items.new(params[:item])

      respond_to do |format|
        if @item.save
          format.html { redirect_to @book, notice: 'Item was successfully created.' }
          format.json { render json: @item, status: :created, location: @item }
        else
          format.html { render action: "new" }
          format.json { render json: @item.errors, status: :unprocessable_entity }
        end
      end
    else

    end
  end

  # PUT /items/1
  # PUT /items/1.json
  def update
    @item = Item.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to items_url }
      format.json { head :no_content }
    end
  end

 private
  def set_and_authorize_book
    if params.has_key?(:book_id) && @book = Book.find(params[:book_id])
      # authorize! :manage, @book
      true
    else
      false
    end
  end
end
