require "spec_helper"
describe Mogli::User do

  let(:app_id) { '12345' }
  let(:access_token) { '678910' }

  describe "#create" do
    it "POSTs to the test user creation url" do
      Mogli::Client.should_receive(:post).with("https://graph.facebook.com/#{app_id}/accounts/test-users",
        :body => {:access_token => access_token, :installed => false, :name => 'The Sock Hammer'}).
        and_return({:id=>1, :login_url => 'http://example.com/hamsocks' })
      user = Mogli::TestUser.create({:installed => false, :name => 'The Sock Hammer'}, Mogli::AppClient.new(access_token, app_id))
      user.login_url.should == 'http://example.com/hamsocks'
    end
  end

  describe "#all" do
    it "GETs the test user url" do
      Mogli::Client.should_receive(:get).with("https://graph.facebook.com/#{app_id}/accounts/test-users",
        :query => {:access_token => access_token}).and_return([{:id=>1, :login_url => 'http://example.com/hamsocks'}])
      users = Mogli::TestUser.all(Mogli::AppClient.new(access_token, app_id))
      users.first.login_url.should == 'http://example.com/hamsocks'
    end
  end
end
