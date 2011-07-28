require "spec_helper"
describe Mogli::Page do
  it "has an access_token" do
    Mogli::Page.new.access_token.should be_nil
  end
  
  it "gets raises an error if the accesstoken is nil" do
    lambda do
      Mogli::Page.new.client_for_page
    end.should raise_error(Mogli::Page::MissingAccessToken)
  end
  
  it "gets a client if access token has been populated" do
    page = Mogli::Page.new
    page.access_token="my token"
    client = page.client_for_page
    client.access_token.should == "my token"
  end

  it "should not raise an error when FB returns # of checkins in page data" do
    Mogli::Client.stub!(:get).and_return({:id=>1, :checkins => 999})
    page = Mogli::Page.new(:id => 1)
    lambda do
      page.fetch
    end.should_not raise_error(NoMethodError)
    page.checkins.should == 999
  end

end
