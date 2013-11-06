class Adm::ItemsController < AdmController
  before_action :set_book, :only => [:new, :create]
  # cancan::load_and_authorize_resource incompatible with strong params
  # load_and_authorize_resource :except => [:index]

  # GET /items
  # GET /items.json
  def index
    @labs = current_admin.labs
    if current_admin.admin? && ( @labs.empty? || params[:all] )
      @items = Item.order("created_at DESC").paginate(:page=>params[:page], :per_page=>50)
      @link_to_my = ! @labs.empty?
      @link_to_all = false
    else
      @link_to_all = current_admin.admin?
      @link_to_my = false
      @items = Item.where(:lab_id => @labs).order("created_at DESC").paginate(:page=>params[:page], :per_page=>50)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @items }
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @item = Item.find(params[:id])
    @book = @item.book
    respond_to do |format|
      format.html { render 'items/show' }
      format.pdf  { @items = [@item] ; render 'items/index' }
      format.json { render json: @item }
    end
  end

  # GET /book/:book_id/items/new
  # GET /book/:book_id/items/new.json
  def new
    @item = @book.items.new
    @labs = current_admin.labs.order('nick ASC').all
    if @labs.empty? && current_admin.admin?
      @labs = Lab.all
    end
    @locations = Location.order('name ASC').all
    @currencies = ENV['CURRENCIES'].split
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/1/edit
  def edit
    @labs = current_admin.available_labs
    @locations = Location.order('name ASC').all
    @currencies = ENV['CURRENCIES'].split
    @item = Item.find(params[:id])
  end

  # POST /book/:book_id/items
  # POST /book/:book_id//items.json
  def create
    @book = Book.find(params[:book_id])
    if @book
      @item = @book.items.new(item_params)
      authorize! :create, @item
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
    authorize! :update, @item

    respond_to do |format|
      if @item.update_attributes(item_params)
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
    authorize! :destroy, @item
    @item.destroy

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end

 private
  def set_book
    if params.has_key?(:book_id) && @book = Book.find(params[:book_id])
      true
    else
      false
    end
  end

  def item_params
    @item_params ||= params.require(:item).permit(:currency, :lab_id, :shelf_id, :location_name, :location_id, :price, :status)
  end

end
