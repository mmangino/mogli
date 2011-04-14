require "spec_helper"
describe Mogli::Profile do
  it "has an image_url" do
    profile = Mogli::Profile.new
    profile.id="1"
    profile.image_url.should == "https://graph.facebook.com/1/picture"
  end
  
  it "has image_url methods for small/large/square" do
    profile = Mogli::Profile.new
    profile.id="1"
    profile.square_image_url.should == "https://graph.facebook.com/1/picture?type=square"
    profile.large_image_url.should == "https://graph.facebook.com/1/picture?type=large"
    profile.small_image_url.should == "https://graph.facebook.com/1/picture?type=small"
  end
end