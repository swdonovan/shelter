require 'rails_helper'

RSpec.describe "Host Shelter Owner Can" do
  before :each do
    Role.create(name: "user")
    Role.create(name: "owner")
    @user = create(:user)
  end

  it "Sees a list of their properties at the Properties Index Page" do
    VCR.use_cassette("features/see_props") do
      @user.properties.create(:street_address => "1331 17th St",
                              :city => "Denver",
                              :state => "Colorado",
                              :rooms_available => 2)

      @user.owner!

     allow_any_instance_of(ApplicationController).to receive(:current_user).
     and_return(@user)

     visit '/host_shelters/properties'

     expect(@user.owner?).to eq true
     expect(current_path).to eq host_shelters_properties_path
     expect(page).to have_content @user.properties.first.street_address
     expect(page).to have_content @user.properties.first.city
     expect(page).to have_content @user.properties.first.state
   end
  end

  it "Sees a list of their properties at the Properties Index Page" do
    VCR.use_cassette("features/see_more_props") do

      @user.properties.create(:street_address => "1701 Bryant St",
                              :city => "Denver",
                              :state => "Colorado",
                              :rooms_available => 2)

      @user.properties.create(:street_address => "1331 17th St",
                              :city => "Denver",
                              :state => "Colorado",
                              :rooms_available => 12)


      @user.owner!

     allow_any_instance_of(ApplicationController).to receive(:current_user).
     and_return(@user)

     visit '/host_shelters/properties'

     expect(@user.owner?).to eq true
     expect(current_path).to eq host_shelters_properties_path

     expect(page).to have_content @user.properties.first.street_address
     expect(page).to have_content @user.properties.first.city
     expect(page).to have_content @user.properties.first.state

     expect(page).to have_content @user.properties.second.street_address
     expect(page).to have_content @user.properties.second.city
     expect(page).to have_content @user.properties.second.state
    end
  end
end
