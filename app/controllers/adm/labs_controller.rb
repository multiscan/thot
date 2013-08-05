class Adm::LabsController < AdmController
  before_action :administrator_only!

  # GET /adm/labs
  # GET /adm/labs.json
  def index
    @labs = Lab.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @labs }
    end
  end

  # GET /adm/labs/1
  # GET /adm/labs/1.json
  def show
    @lab = Lab.find(params[:id], :include => [:users, :operators])
    @users = @lab.users
    @admins = @lab.operators

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lab }
    end
  end

  # GET /adm/labs/new
  # GET /adm/labs/new.json
  def new
    @lab = Lab.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lab }
    end
  end

  # GET /adm/labs/1/edit
  def edit
    @lab = Lab.find(params[:id])
  end

  # POST /adm/labs
  # POST /adm/labs.json
  def create
    @lab = Lab.new(lab_params)

    respond_to do |format|
      if @lab.save
        format.html { redirect_to [:adm, @lab], notice: 'Lab was successfully created.' }
        format.json { render json: @lab, status: :created, location: @lab }
      else
        format.html { render action: "new" }
        format.json { render json: @lab.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /adm/labs/1
  # PUT /adm/labs/1.json
  def update
    @lab = Lab.find(params[:id])

    respond_to do |format|
      if @lab.update_attributes(lab_params)
        format.html { redirect_to [:adm, @lab], notice: 'Lab was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lab.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /adm/labs/1
  # DELETE /adm/labs/1.json
  def destroy
    @lab = Lab.find(params[:id])
    @lab.destroy

    respond_to do |format|
      format.html { redirect_to adm_labs_url }
      format.json { head :no_content }
    end
  end

 private

  def lab_params
    params.require(:lab).permit :name, :nick
  end

end
