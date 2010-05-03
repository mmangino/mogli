require "spec_helper"
describe Mogli::Client do
  let :client do
    Mogli::Client.new
  end
  
  it "fetches a user by id" do
    client.should_receive(:get_and_map).with(12451752,Mogli::User).and_return("user")
    client.user(12451752).should == "user"
  end
  
end