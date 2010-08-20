require "spec_helper"
describe Mogli::Profile do
  it "has an image_url" do
    profile = Mogli::Profile.new
    profile.id="1"
    profile.image_url.should == "https://graph.facebook.com/1/picture"
  end
end