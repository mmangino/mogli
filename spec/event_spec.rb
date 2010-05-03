require "spec_helper"
describe Mogli::Event do
  
  let :event_1 do
    event_1 = Mogli::Event.new(:id=>1)
    event_1.client = mock_client
    event_1
  end
  
  let :mock_client do
    mock("client")
  end
  
  it "allow setting the client" do
    event = Mogli::Event.new
    event.client = "client"
    event.client.should == "client"
  end
  
  it "have a noreply attribute which fetches when called" do
    mock_client.should_receive(:get_and_map).with("/1/noreply","User").and_return("noreply")
    event_1.noreply.should == "noreply"
  end
  
  it "only fetch noreply once" do
    mock_client.should_receive(:get_and_map).once.with("/1/noreply","User").and_return([])
    event_1.noreply
    event_1.noreply
  end
  
  it "will recognize itself" do
    Mogli::Event.recognize?("id"=>1,"name"=>"Ruby Hackfest")    
  end
end
