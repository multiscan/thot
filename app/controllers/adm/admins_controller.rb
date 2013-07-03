class Adm::AdminsController < AdmController
  before_action :administrator_only!

  # GET /adm/admins
  # GET /adm/admins.json
  def index
    @admins = Admin.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @admins }
    end
  end

  # GET /adm/admins/1
  # GET /adm/admins/1.json
  def show
    @admin = Admin.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admin }
    end
  end

  # GET /adm/admins/new
  # GET /adm/admins/new.json
  def new
    @admin = Admin.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @admin }
    end
  end

  # GET /adm/admins/1/edit
  def edit
    @admin = Admin.find(params[:id])
  end

  # POST /adm/admins
  # POST /adm/admins.json
  def create
    @admin = Admin.new(admin_params)

    respond_to do |format|
      if @admin.save
        format.html { redirect_to [:adm, @admin], notice: 'Admin was successfully created.' }
        format.json { render json: @admin, status: :created, location: @admin }
      else
        format.html { render action: "new" }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /adm/admins/1
  # PUT /adm/admins/1.json
  def update
    @admin = Admin.find(params[:id])

    respond_to do |format|
      if @admin.update_attributes(admin_params)
        format.html { redirect_to [:adm, @admin], notice: 'Admin was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /adm/admins/1
  # DELETE /adm/admins/1.json
  def destroy
    @admin = Admin.find(params[:id])
    @admin.destroy

    respond_to do |format|
      format.html { redirect_to adm_admins_url }
      format.json { head :no_content }
    end
  end

 private

  def admin_params
    params.require(:admin).permit :name, :email, :role, :password, :password_confirmation, :remember_me, :lab_ids => []
  end

end
