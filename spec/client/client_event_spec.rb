require "spec_helper"
describe Mogli::Client do
  let :client do
    Mogli::Client.new
  end
  
  it "fetches an event by id" do
    client.should_receive(:get_and_map).with(118515001510745,Mogli::Event).and_return("event")
    client.event(118515001510745).should == "event"
  end
  
end
