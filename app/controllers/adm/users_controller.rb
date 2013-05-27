class Adm::UsersController < ApplicationController
  before_filter :authenticate_admin!
  load_and_authorize_resource :except => :autocomplete_location_name

  # autocomplete :location, :name, :full => true

  # GET /admin/users
  # GET /admin/users.json
  def index
    # @users =
    #   if current_admin.role?("admin")
    #     User.all(:include=>[:lab, :loans], :order => :name)
    #   else
    #     User.where({:lab_id => current_admin.labs.map{|l| l.id}}, :include=>[:lab, :loans], :order => :name)
    #   end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /admin/users/1
  # GET /admin/users/1.json
  def show
    # @user = Admin::User.find(params[:id])
    @loans = @user.loans
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /admin/users/new
  # GET /admin/users/new.json
  def new
    @user = Admin::User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /admin/users/1/edit
  def edit
    # @user = Admin::User.find(params[:id])
  end

  # POST /admin/users
  # POST /admin/users.json
  def create
    @user = Admin::User.new(params[:user])

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
    @user = Admin::User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
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
    @user = Admin::User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

end
