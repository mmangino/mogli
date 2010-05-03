require "spec_helper"
describe Mogli::User do
  
  let :user_1 do
    user_1 = Mogli::User.new(:id=>1)
    user_1.client = mock_client
    user_1
  end
  
  let :mock_client do
    mock("client")
  end
  
  it "allow setting the client" do
    user = Mogli::User.new
    user.client = "client"
    user.client.should == "client"
  end
  
  it "have an activities attribute which fetches when called" do
    mock_client.should_receive(:get_and_map).with("/1/activities","Activity").and_return("activities")
    user_1.activities.should == "activities"
  end
  
  it "only fetch activities once" do
    mock_client.should_receive(:get_and_map).once.with("/1/activities","Activity").and_return([])
    user_1.activities
    user_1.activities
  end
  
  it "won't recognize pages" do
    Mogli::User.recognize?("id"=>1,"name"=>"bob","category"=>"fdhsjkfsd")
  end
  
  it "will recognize itself" do
    Mogli::User.recognize?("id"=>1,"name"=>"bob")    
  end
  
  it "should emit warnings when properties that don't exist are written to" do
    m=Mogli::User.new
    m.should_receive(:warn_about_invalid_property).with("doesnt_exist")
    m.doesnt_exist=1
  end
end