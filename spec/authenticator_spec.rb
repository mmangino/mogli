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

  it "creates the authorize_url with scopes as an array" do
    authenticator.authorize_url(:scope=>[:user_photos,:user_videos,:stream_publish]).should ==
      "https://graph.facebook.com/oauth/authorize?client_id=123456&redirect_uri=http%3A%2F%2Fexample.com%2Furl&scope=user_photos,user_videos,stream_publish"
  end

  it "creates the access_token_url" do
    authenticator.access_token_url("mycode").should == "https://graph.facebook.com/oauth/access_token?client_id=123456&redirect_uri=http%3A%2F%2Fexample.com%2Furl&client_secret=secret&code=mycode"
  end

  it "can trade session_keys for access_tokens" do
    Mogli::Client.should_receive(:post).
      with("https://graph.facebook.com/oauth/exchange_sessions",
           :body => {:type => "client_cred", :client_id => "123456",
                     :client_secret => "secret",
                     :sessions => "mysessionkey,yoursessionkey"}).
      and_return([{"access_token" => "myaccesstoken",   "expires" => 5000},
                  {"access_token" => "youraccesstoken", "expires" => 5000}])

    authenticator.
      get_access_token_for_session_key(["mysessionkey","yoursessionkey"]).
      should == [{"access_token" => "myaccesstoken",   "expires" => 5000},
                 {"access_token" => "youraccesstoken", "expires" => 5000}]
  end

  it "can trade one session_key for an access_tokens" do
    Mogli::Client.should_receive(:post).
      with("https://graph.facebook.com/oauth/exchange_sessions",
           :body => {:type => "client_cred", :client_id => "123456",
                     :client_secret => "secret", :sessions => "mysessionkey"}).
      and_return({"access_token" => "myaccesstoken", "expires" => 5000})

    authenticator.
      get_access_token_for_session_key("mysessionkey").
      should == {"access_token" => "myaccesstoken", "expires" => 5000}
  end

end
