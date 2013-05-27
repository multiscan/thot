require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe Adm::AdminsController do

  # This should return the minimal set of attributes required to create a valid
  # Adm::Admin. As you add validations to Adm::Admin, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {  }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Adm::AdminsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all adm_admins as @adm_admins" do
      admin = Adm::Admin.create! valid_attributes
      get :index, {}, valid_session
      assigns(:adm_admins).should eq([admin])
    end
  end

  describe "GET show" do
    it "assigns the requested adm_admin as @adm_admin" do
      admin = Adm::Admin.create! valid_attributes
      get :show, {:id => admin.to_param}, valid_session
      assigns(:adm_admin).should eq(admin)
    end
  end

  describe "GET new" do
    it "assigns a new adm_admin as @adm_admin" do
      get :new, {}, valid_session
      assigns(:adm_admin).should be_a_new(Adm::Admin)
    end
  end

  describe "GET edit" do
    it "assigns the requested adm_admin as @adm_admin" do
      admin = Adm::Admin.create! valid_attributes
      get :edit, {:id => admin.to_param}, valid_session
      assigns(:adm_admin).should eq(admin)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Adm::Admin" do
        expect {
          post :create, {:adm_admin => valid_attributes}, valid_session
        }.to change(Adm::Admin, :count).by(1)
      end

      it "assigns a newly created adm_admin as @adm_admin" do
        post :create, {:adm_admin => valid_attributes}, valid_session
        assigns(:adm_admin).should be_a(Adm::Admin)
        assigns(:adm_admin).should be_persisted
      end

      it "redirects to the created adm_admin" do
        post :create, {:adm_admin => valid_attributes}, valid_session
        response.should redirect_to(Adm::Admin.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved adm_admin as @adm_admin" do
        # Trigger the behavior that occurs when invalid params are submitted
        Adm::Admin.any_instance.stub(:save).and_return(false)
        post :create, {:adm_admin => {  }}, valid_session
        assigns(:adm_admin).should be_a_new(Adm::Admin)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Adm::Admin.any_instance.stub(:save).and_return(false)
        post :create, {:adm_admin => {  }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested adm_admin" do
        admin = Adm::Admin.create! valid_attributes
        # Assuming there are no other adm_admins in the database, this
        # specifies that the Adm::Admin created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Adm::Admin.any_instance.should_receive(:update_attributes).with({ "these" => "params" })
        put :update, {:id => admin.to_param, :adm_admin => { "these" => "params" }}, valid_session
      end

      it "assigns the requested adm_admin as @adm_admin" do
        admin = Adm::Admin.create! valid_attributes
        put :update, {:id => admin.to_param, :adm_admin => valid_attributes}, valid_session
        assigns(:adm_admin).should eq(admin)
      end

      it "redirects to the adm_admin" do
        admin = Adm::Admin.create! valid_attributes
        put :update, {:id => admin.to_param, :adm_admin => valid_attributes}, valid_session
        response.should redirect_to(admin)
      end
    end

    describe "with invalid params" do
      it "assigns the adm_admin as @adm_admin" do
        admin = Adm::Admin.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Adm::Admin.any_instance.stub(:save).and_return(false)
        put :update, {:id => admin.to_param, :adm_admin => {  }}, valid_session
        assigns(:adm_admin).should eq(admin)
      end

      it "re-renders the 'edit' template" do
        admin = Adm::Admin.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Adm::Admin.any_instance.stub(:save).and_return(false)
        put :update, {:id => admin.to_param, :adm_admin => {  }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested adm_admin" do
      admin = Adm::Admin.create! valid_attributes
      expect {
        delete :destroy, {:id => admin.to_param}, valid_session
      }.to change(Adm::Admin, :count).by(-1)
    end

    it "redirects to the adm_admins list" do
      admin = Adm::Admin.create! valid_attributes
      delete :destroy, {:id => admin.to_param}, valid_session
      response.should redirect_to(adm_admins_url)
    end
  end

end