class Adm::ShelvesController < AdmController

  # GET /adm/shelves/1
  def index
    @shelves = Shelf.all
  end

  # GET /adm/inventory_sessions/:inventory_session_id/shelves/:id
  def show
    @inventory_session = InventorySession.find(params[:inventory_session_id])
    @shelf = Shelf.find(params[:id])
    @confirmed= @inventory_session.goods.where(previous_shelf_id: @shelf.id, current_shelf_id: @shelf.id)
    @missing  = @inventory_session.goods.where(previous_shelf_id: @shelf.id, current_shelf_id: nil)
    @imported = @inventory_session.goods.where(previous_shelf_id: nil, current_shelf_id: @shelf.id)
    @moved_in = @inventory_session.goods.where("previous_shelf_id != ? AND current_shelf_id = ?", @shelf.id, @shelf.id)

    gon.inventory = @inventory_session.id
    gon.shelf = @shelf.id
    respond_to do |format|
      format.html
    end
  end

  # POST /adm/location/id/shelves
  # POST /adm/labs.json
  def create
    @location = Location.find(params[:location_id])
    @shelf =  @location.shelves.new
    respond_to do |format|
      if @shelf.save
        format.html { redirect_to @location, notice: 'Shelf added.' }
        format.js { render js: "thot.increase_counter('#shc_#{@location.id}');" }
      else
        format.html { render action: "new" }
        format.json { render json: @lab.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /adm/shelves/1
  def destroy
    @shelf = Shelf.find(params[:id])

    respond_to do |format|
      if can? :destroy, @shelf
        @shelf.destroy
        format.html { redirect_back_or_default(adm_shelves_url, :notice => "Shelf destroyed") }
        format.js { render :js => "thot.fade_and_remove('#shelf_#{@shelf.id}');"}
      else
        format.html { redirect_back_or_default(adm_shelves_url, :error => "Could not delete shelf. May be it contains items.") }
        format.js { render :js => "thot.alert('Could not delete shelf. May be it contains items.');"}
      end
    end
  end
end
