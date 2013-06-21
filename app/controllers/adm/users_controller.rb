class Adm::UsersController < AdmController
  load_and_authorize_resource :except => [:index]

  # GET /admin/users
  # GET /admin/users.json
  def index
    # @users =
    #   if current_admin.role?("admin")
    #     User.all(:include=>[:lab, :loans], :order => :name)
    #   else
    #     User.where({:lab_id => current_admin.labs.map{|l| l.id}}, :include=>[:lab, :loans], :order => :name)
    #   end
    if current_admin.admin? && params[:my].nil?
      @users = Users.all
      @link_to_my = true
    else
      @users = current_admin.users
      @link_to_all = current_admin.admin?
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /admin/users/1
  # GET /admin/users/1.json
  def show
    # @user = User.find(params[:id])
    @loans = @user.loans
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /admin/users/new
  # GET /admin/users/new.json
  def new
    @user = User.new
    @labs = current_admin.labs
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /admin/users/1/edit
  def edit
    @labs = current_admin.labs
    # @user = User.find(params[:id])
  end

  # POST /admin/users
  # POST /admin/users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to [:adm, @user], notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/users/1
  # PUT /admin/users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to [:adm, @user], notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/users/1
  # DELETE /admin/users/1.json
  def destroy
    @user = User.find(params[:id])

    respond_to do |format|
      if can? :destroy, @user
        @user.destroy
        format.html { redirect_to adm_users_url, notice: "User #{@user.name} destroyed." }
        format.json { head :no_content }
      else
        format.html { user_not_authorized(adm_users_url) }
        format.json { render json: no_content, status: :unprocessable_entity }
      end
    end
  end

end
