require "spec_helper"
describe Ogli::Client do
  let :client do
    Ogli::Client.new
  end
  
  it "fetches a user by id" do
    client.should_receive(:get_and_map).with(12451752,Ogli::User).and_return("user")
    client.user(12451752).should == "user"
  end
  
end