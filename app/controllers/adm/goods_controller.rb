class Adm::GoodsController < AdmController

  # POST /adm/goods
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

  # # GET /adm/goods/:id/uncheck
  # def uncheck
  #   @good = Good.find(:id)
  #   respond_to do |format|
  #     if can? :update, @good
  #       @good.current_shelf=nil
  #       respond_to do |format|
  #         format.js
  #       end
  #     else
  #       respond_to do |format|
  #         format.js {  render :js => "window.location = '/'", :status => :unauthorized }
  #       end
  #     end
  #   end
  # end

  # # GET /adm/inventory_sessions/:inventory_session_id/:inv/edit
  # def edit
  #   @inventory_session = inventorySession.find(params[:inventory_session])
  #   @good = @inventory_session.goods.where(:inv=>params[:id])
  #   respond_to do |format|
  #     format.js
  #   end
  # end

  # def update
  # end
end
