require 'spec_helper'

describe "adm/admins/show" do
  before(:each) do
    @adm_admin = assign(:adm_admin, stub_model(Adm::Admin))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
