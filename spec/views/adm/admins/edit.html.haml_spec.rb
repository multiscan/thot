require 'spec_helper'

describe "adm/admins/edit" do
  before(:each) do
    @adm_admin = assign(:adm_admin, stub_model(Adm::Admin))
  end

  it "renders the edit adm_admin form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => adm_admins_path(@adm_admin), :method => "post" do
    end
  end
end
