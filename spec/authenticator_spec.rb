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
    response = mock('HTTParty::Response',
      :parsed_response => [
          {"access_token" => "myaccesstoken",   "expires" => 5000},
          {"access_token" => "youraccesstoken", "expires" => 5000}
        ],
      :code => 200)
    response.stub!(:code).and_return(200)

    Mogli::Client.should_receive(:post).
      with("https://graph.facebook.com/oauth/exchange_sessions",
           :body => {:type => "client_cred", :client_id => "123456",
                     :client_secret => "secret",
                     :sessions => "mysessionkey,yoursessionkey"}).
      and_return(response)

    authenticator.
      get_access_token_for_session_key(["mysessionkey","yoursessionkey"]).
      should == [{"access_token" => "myaccesstoken",   "expires" => 5000},
                 {"access_token" => "youraccesstoken", "expires" => 5000}]
  end

  it "can trade one session_key for an access_token" do
    response = mock('HTTParty::Response',
      :parsed_response => [
          {"access_token" => "myaccesstoken", "expires" => 5000}
        ],
      :code => 200)

    Mogli::Client.should_receive(:post).
      with("https://graph.facebook.com/oauth/exchange_sessions",
           :body => {
             :type => "client_cred",
             :client_id => "123456",
             :client_secret => "secret",
             :sessions => "mysessionkey"
          }).
      and_return(response)

    authenticator.
      get_access_token_for_session_key("mysessionkey").
      should == {"access_token" => "myaccesstoken", "expires" => 5000}
  end

  it "can ask for an application token" do
    response = mock('HTTParty::Response',
      :parsed_response => "access_token=123456|3SDdfgdfgv0bbEvYjBH5tJtl-dcBdsfgo",
      :code => 200)

    Mogli::Client.should_receive(:post).
      with("https://graph.facebook.com/oauth/access_token",
           :body=> {
             :grant_type => 'client_credentials',
             :client_id => "123456",
             :client_secret => "secret"
           }).
      and_return(response)


      token = authenticator.get_access_token_for_application
      token.should =="123456|3SDdfgdfgv0bbEvYjBH5tJtl-dcBdsfgo"
  end

  it "raises an error if not a 200" do
    response = mock('HTTParty::Response',
      :parsed_response => "access_token=123456|3SDdfgdfgv0bbEvYjBH5tJtl-dcBdsfgo",
      :code => 500)

    Mogli::Client.should_receive(:post).and_return(response)
    lambda do
      token = authenticator.get_access_token_for_application
    end.should raise_error(Mogli::Client::HTTPException)

  end

  context "Oauth2" do
    let :oauth2_authenticator do
      Mogli::Authenticator.new("123456","secret",nil)
    end
    it "creates the access_token_url without a redirect URL" do
      oauth2_authenticator.access_token_url("mycode").should == "https://graph.facebook.com/oauth/access_token?client_id=123456&redirect_uri=&client_secret=secret&code=mycode"
    end
  end

end
