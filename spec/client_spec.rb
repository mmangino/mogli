require "spec_helper"
describe Mogli::Client do

  let :client do
    Mogli::Client.new
  end


  describe "creation" do
    it "allows creating with an access_token" do
      client = Mogli::Client.new("myaccesstoken")
      client.access_token.should == "myaccesstoken"
    end

    it "allows creating with a session_key" do
      Time.stub!(:now).and_return(1270000000)
      authenticator = Mogli::Authenticator.new('123456', 'secret', nil)
      authenticator.should_receive(:get_access_token_for_session_key).
                    with('mysessionkey').
                    and_return({'access_token' => 'myaccesstoken',
                                'expires' => 5000})
      Mogli::Authenticator.should_receive(:new).and_return(authenticator)
      client = Mogli::Client.create_from_session_key(
                 'mysessionkey', '123456', 'secret')
      client.access_token.should == 'myaccesstoken'
      client.expiration.should == Time.at(1270005000)
    end

    it "sets the access_token into the default params" do
      client = Mogli::Client.new("myaccesstoken")
      client.default_params.should == {:access_token=>"myaccesstoken"}
    end

    it "sets the expiration time if provided" do
      old_now=Time.now
      Time.stub!(:now).and_return(old_now)
      client = Mogli::Client.new("myaccesstoken",old_now.to_i)
      client.expiration.to_i.should == old_now.to_i
    end

    it "should know if the session is expired" do
      client = Mogli::Client.new("myaccesstoken",Time.now - 100)
      client.should be_expired
    end

    it "allow creation with no access token" do
      client = Mogli::Client.new
      client.access_token.should be_nil
    end

    it "doesn't include the access_token param when not passed" do
      client = Mogli::Client.new
      client.default_params.should == {}
    end

    it "create get access token from an authenticator and code" do
      Mogli::Client.should_receive(:get).with("url").and_return("access_token=114355055262088|2.6_s8VD_HRneAq3_tUEHJhA__.3600.1272920400-12451752|udZzWly7ptI7IMgX7KTdzaoDrhU.&expires=4168")
      client = Mogli::Client.create_from_code_and_authenticator("code",mock("auth",:access_token_url=>"url"))
      client.access_token.should == "114355055262088|2.6_s8VD_HRneAq3_tUEHJhA__.3600.1272920400-12451752|udZzWly7ptI7IMgX7KTdzaoDrhU."
      client.expiration.should_not be_nil
    end

    it "create set the expiration into the future if there is on param" do
      Mogli::Client.should_receive(:get).with("url").and_return("access_token=114355055262088|2.6_s8VD_HRneAq3_tUEHJhA__.3600.1272920400-12451752|udZzWly7ptI7IMgX7KTdzaoDrhU.")
      client = Mogli::Client.create_from_code_and_authenticator("code",mock("auth",:access_token_url=>"url"))
      (client.expiration > Time.now+365*24*60*60).should be_true
    end

  end


  describe "Making requests" do
    it "posts with the parameters in the body" do
      Mogli::Client.should_receive(:post).with("https://graph.facebook.com/1/feed",:body=>{:message=>"message",:access_token=>"1234"})
      client = Mogli::Client.new("1234")
      client.post("1/feed","Post",:message=>"message")
    end

    it "parses errors in the returns of posts" do
      Mogli::Client.should_receive(:post).and_return({"error"=>{"type"=>"OAuthAccessTokenException","message"=>"An access token is required to request this resource."}})
      client = Mogli::Client.new("1234")
      lambda do
        result = client.post("1/feed","Post",:message=>"message")
      end.should raise_error
    end

    it "creates objects of the returned type" do
      Mogli::Client.should_receive(:post).and_return({:id=>123434})
      client = Mogli::Client.new("1234")
      result = client.post("1/feed","Post",:message=>"message")
      result.should == Mogli::Post.new(:id=>123434)
    end
    
  end

  it "allows deleting" do
    Mogli::Client.should_receive(:delete).with("https://graph.facebook.com/1",:query=>{:access_token=>"1234"})
    client = Mogli::Client.new("1234")
    client.delete("1")
  end


  describe "fql queries" do 
    it "defaults to json" do
      Mogli::Client.should_receive(:post).with("https://api.facebook.com/method/fql.query",:body=>{:query=>"query",:format=>"json",:access_token=>"1234"})
      client = Mogli::Client.new("1234")
      client.fql_query("query")
    end

    it "supports xml" do 
      Mogli::Client.should_receive(:post).with("https://api.facebook.com/method/fql.query",:body=>{:query=>"query",:format=>"xml",:access_token=>"1234"})
      client = Mogli::Client.new("1234")
      client.fql_query("query",nil,"xml")  
    end

    it "creates objects if given a class" do
      Mogli::Client.should_receive(:post).and_return({"id"=>12451752, "first_name"=>"Mike", "last_name"=>"Mangino" })
      client = Mogli::Client.new("1234")
      client.fql_query("query","user").should be_an_instance_of(Mogli::User)
    end

    it "returns a hash if no class is given" do
      Mogli::Client.should_receive(:post).and_return({"id"=>12451752, "first_name"=>"Mike", "last_name"=>"Mangino" })
      client = Mogli::Client.new("1234")
      client.fql_query("query").should be_an_instance_of(Hash)
    end
    
    it "doesn't create objects if the format is xml" do 
      Mogli::Client.should_receive(:post).and_return({"id"=>12451752, "first_name"=>"Mike", "last_name"=>"Mangino" })
      client = Mogli::Client.new("1234")
      client.fql_query("query","user","xml").should be_an_instance_of(Hash)    
    end  
  end
  
  describe "result mapping" do

    let :user_data do
       {"id"=>12451752, "first_name"=>"Mike", "last_name"=>"Mangino" }
    end

    it "returns the raw value with no class specified" do
      client.map_data(user_data).should be_an_instance_of(Hash)
    end

    it "returns the array if no class is specified and there is only a data parameter" do
      client.map_data({"data"=>[user_data,user_data]}).should be_kind_of(Array)
    end


    it "creates an instance of the class when specified" do
      user = client.map_data(user_data,Mogli::User)
      user.should be_an_instance_of(Mogli::User)
      user.id.should == 12451752
    end

    it "creates an array of instances when the data is an array" do
      users = client.map_data([user_data,user_data],Mogli::User)
      users.should be_an_instance_of(Array)
      users.each {|i| i.should be_an_instance_of(Mogli::User) }
      users.size.should == 2
    end

    it "creates an array of instances when the data is just a hash with a single data parameter" do
      users = client.map_data({"data"=>[user_data,user_data]},Mogli::User)
      users.should be_kind_of(Array)
      users.each {|i| i.should be_an_instance_of(Mogli::User) }
      users.size.should == 2
    end

    it "create an instance of fetching array when there is a data element" do
      users = client.map_data({"data"=>[user_data,user_data]},Mogli::User)
      users.should be_an_instance_of(Mogli::FetchingArray)
    end

    it "sets the client on the array" do
      users = client.map_data({"data"=>[user_data,user_data]},Mogli::User)
      users.client.should == client
    end

    it "sets the next url on the array" do
      users = client.map_data({"data"=>[user_data,user_data],"paging"=>{"next"=>"next"}},Mogli::User)
      users.next_url.should == "next"
    end

    it "sets the previous url on the array" do
      users = client.map_data({"data"=>[user_data,user_data],"paging"=>{"previous"=>"prev"}},Mogli::User)
      users.previous_url.should == "prev"
    end

    it "sets the classes on the array" do
      users = client.map_data({"data"=>[user_data,user_data],"paging"=>{"previous"=>"prev"}},Mogli::User)
      users.classes.should == [Mogli::User]
    end

    it "sets the client in the newly created instance" do
      user = client.map_data(user_data,Mogli::User)
      user.client.should == client
    end

    it "returns nil if Facebook says false" do
      Mogli::Client.should_receive(:get).and_return(false)
      client.get_and_map(148800401968,"User").should be_nil
    end

    it "raises an exception when there is just an error" do
      lambda do
        client.map_data({"error"=>{"type"=>"OAuthAccessTokenException","message"=>"An access token is required to request this resource."}})
      end.should raise_error
    end

    it "should set the message on the exception" do
      begin
        client.map_data({"error"=>{"type"=>"OAuthAccessTokenException","message"=>"An access token is required to request this resource."}})
        fail "Exception not raised!"
      rescue Exception => e
        e.message.should == "OAuthAccessTokenException: An access token is required to request this resource."
      end
    end

    describe "Instance creation" do
      it "will find the class in the Mogli namespace if given a string" do
        client.create_instance("User",{:id=>1}).should be_an_instance_of(Mogli::User)
      end
      
      it "will NOT use the value from the type field if it exists" do
        client.create_instance("Post",{:id=>1,"type"=>"status"}).should be_an_instance_of(Mogli::Post)
      end

      it "call the recognize method on each class passing the data and will use the one that recognizes it" do
        Mogli::User.should_receive(:recognize?).with(:id=>1).and_return(false)
        Mogli::Post.should_receive(:recognize?).with(:id=>1).and_return(true)
        client.create_instance(["User","Post"],{:id=>1}).should be_an_instance_of(Mogli::Post)
      end

      it "will use the first class if none are recognized" do
        Mogli::Page.should_receive(:recognize?).with(:id=>1).and_return(false)
        client.create_instance(["Page"],{:id=>1}).should be_an_instance_of(Mogli::Page)
      end
    end
  end

end
