require 'spec_helper'

describe "adm/admins/new" do
  before(:each) do
    assign(:adm_admin, stub_model(Adm::Admin).as_new_record)
  end

  it "renders new adm_admin form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => adm_admins_path, :method => "post" do
    end
  end
end
