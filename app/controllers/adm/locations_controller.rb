class Adm::LocationsController < AdmController
  # GET /adm/locations
  # GET /adm/locations.json
  def index
    if current_admin.admin? && params[:my].nil?
      @locations = Location.all.includes(:items, :shelves)
      @link_to_my = true
    else
      @locations = current_admin.locations # .includes(:items, :shelves)
      @link_to_all = current_admin.admin?
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @locations }
    end
  end

  # GET /adm/locations/1
  # GET /adm/locations/1.json
  def show
    @location = Location.find(params[:id])
    @shelves = @location.shelves
    @items = @location.items.paginate(page: params[:page], per_page: 50)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @location }
    end
  end

  # GET /adm/locations/new
  # GET /adm/locations/new.json
  def new
    @location = Location.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @location }
    end
  end

  # GET /adm/locations/1/edit
  def edit
    @location = Location.find(params[:id])
  end

  # POST /adm/locations
  # POST /adm/locations.json
  def create
    @location = Location.new(location_params)

    respond_to do |format|
      if @location.save
        format.html { redirect_to adm_locations_url, notice: "Location #{@location.name} was successfully created." }
        format.json { render json: @location, status: :created, location: @location }
      else
        format.html { render action: "new" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /adm/locations/1
  # PUT /adm/locations/1.json
  def update
    @location = Location.find(params[:id])

    respond_to do |format|
      if @location.update_attributes(location_params)
        format.html { redirect_to adm_locations_url, notice: "Location #{@location.name} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /adm/locations/1
  # DELETE /adm/locations/1.json
  def destroy
    @location = Location.find(params[:id])
    @location.destroy

    respond_to do |format|
      format.html { redirect_to adm_locations_url }
      format.json { head :no_content }
    end
  end

 private

  def location_params
    params.require(:location).permit(:name)
  end

end
