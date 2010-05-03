require "spec_helper"
describe Mogli::Authenticator do
  
  let :authenticator do
    Mogli::Authenticator.new("123456","secret","http://example.com/url")
  end
  
  it "has the client id" do
    authenticator.client_id.should == "123456"
  end
  
  it "has the secret" do
    authenticator.secret.should == "secret"
  end
  
  it "has the callback url" do
    authenticator.callback_url.should == "http://example.com/url"
  end
  
  it "creates the authorize_url" do
    authenticator.authorize_url.should == "https://graph.facebook.com/oauth/authorize?client_id=123456&redirect_uri=http%3A%2F%2Fexample.com%2Furl"
  end
  
  it "creates the access_token_url" do
    authenticator.access_token_url("mycode").should == "https://graph.facebook.com/oauth/access_token?client_id=123456&redirect_uri=http%3A%2F%2Fexample.com%2Furl&client_secret=secret&code=mycode"
  end
end
