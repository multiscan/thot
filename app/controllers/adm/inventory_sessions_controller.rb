class Adm::InventorySessionsController < AdmController

  # POST /adm/inventory_sessions/inventorize_search
  def inventorize_search
    isid = params["inventorize"]["session_id"]
    puts "--------- isid=#{isid}   blank? #{isid.blank?}   nil? #{isid.nil?}"
    search = Search.find(params["inventorize"]["search_id"])
    if isid.nil? || isid.blank?
      redirect_to search, :notice => "Please select and inventory session"
    else
      @inventory_session = InventorySession.find(params["inventorize"]["session_id"])
      @inventory_session.inventorize_search(search)
      redirect_to [:adm, @inventory_session]
    end
  end

  # POST /adm/inventory_sessions/:id/check/:inv
  def check
    @inventory_session = InventorySession.find(params[:inventory_session_id])
    @shelf = Shelf.find(params[:shelf])
    @good = @inventory_session.goods.where(item_id: params[:inv]).first
    respond_to do |format|
      if @good
        @good.update_attribute(:current_shelf_id, @shelf.id)
        format.json { render json: { good: @good, status: @good.status(@shelf.id), id: "inv_#{@good.inv}", li: render_to_string(:partial => 'adm/goods/good', :layout => false, :formats => [:html], :locals => { :good => @good }) } }
      else
        format.json { render json: { good: false, message: "The item you have scanned is not among the goods of this inventory session"}, status: :not_found }
      end
    end
  end

  # GET /adm/inventory_sessions/:id/commit_moves
  def commit_moves
    @inventory_session = InventorySession.find(params[:inventory_session_id])
    n = @inventory_session.commit_moves
    respond_to do |format|
      format.html { redirect_to [:adm, @inventory_session], :notice => "#{n} moves committed." }
    end
  end

  # GET /adm/inventory_sessions/:id/commit_missings
  def commit_missings
    @inventory_session = InventorySession.find(params[:inventory_session_id])
    n = @inventory_session.commit_missings
    respond_to do |format|
      format.html { redirect_to [:adm, @inventory_session], :notice => "#{n} missing committed." }
    end
  end

  # GET /adm/inventory_sessions
  # GET /adm/inventory_sessions.json
  def index
    if current_admin.admin? and not params[:mine_only]
      @all = true
      @inventory_sessions = InventorySession.all
    else
      @all = false
      @inventory_sessions = current_admin.inventory_sessions
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @inventory_sessions }
    end
  end

  # GET /adm/inventory_sessions/1
  # GET /adm/inventory_sessions/1.json
  def show
    @inventory_session = InventorySession.find(params[:id])
    @shelves = @inventory_session.shelves
    gon.inventory = @inventory_session.id
    respond_to do |format|
      format.pdf
      format.html # show.html.erb
      format.json { render json: @inventory_session }
      format.csv {
        @records = [["Inv", "Lab", "Call1", "Call2", "Call3", "Title"]]
        @records += @inventory_session.books_by_call_for_listing.map{|r| [r.id, r.lab_nick, r.call1, r.call2, r.call3, r.title]}
        send_data CSV.generate {|csv| @records.each {|r| csv << r} }
      }
      format.xls # renders show.xls.erb
      # format.xls {
      #   @records = [["Inv", "Lab", "Call1", "Call2", "Call3", "Title"]]
      #   @records += @inventory_session.books_by_call_for_listing.map{|r| [r.id, r.lab_nick, r.call1, r.call2, r.call3, r.title]}
      #   send_data CSV.generate(col_sep: "\t") {|csv| @records.each {|r| csv << r} }
      # }
    end
  end

  # GET /adm/inventory_sessions/new
  # GET /adm/inventory_sessions/new.json
  def new
    @inventory_session = InventorySession.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @inventory_session }
    end
  end

  # GET /adm/inventory_sessions/1/edit
  def edit
    @inventory_session = InventorySession.find(params[:id])
  end

  # POST /adm/inventory_sessions
  # POST /adm/inventory_sessions.json
  def create
    @inventory_session = InventorySession.new(inventory_session_params)
    @inventory_session.admin ||= current_admin
    respond_to do |format|
      if @inventory_session.save
        format.html { redirect_to [:adm, @inventory_session], notice: 'Inventory session was successfully created.' }
        format.json { render json: @inventory_session, status: :created, location: @inventory_session }
      else
        format.html { render action: "new" }
        format.json { render json: @inventory_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /adm/inventory_sessions/1
  # PUT /adm/inventory_sessions/1.json
  def update
    @inventory_session = InventorySession.find(params[:id])

    respond_to do |format|
      if @inventory_session.update_attributes(inventory_session_params)
        format.html { redirect_to [:adm, @inventory_session], notice: 'Inventory session was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @inventory_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /adm/inventory_sessions/1
  # DELETE /adm/inventory_sessions/1.json
  def destroy
    @inventory_session = InventorySession.find(params[:id])
    @inventory_session.destroy

    respond_to do |format|
      format.html { redirect_to adm_inventory_sessions_url }
      format.json { head :no_content }
    end
  end

 private

  def inventory_session_params
    params.require(:inventory_session).permit(:name, :notes)
  end
end
