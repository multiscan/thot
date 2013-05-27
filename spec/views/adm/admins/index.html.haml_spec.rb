require 'spec_helper'

describe "adm/admins/index" do
  before(:each) do
    assign(:adm_admins, [
      stub_model(Adm::Admin),
      stub_model(Adm::Admin)
    ])
  end

  it "renders a list of adm/admins" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
