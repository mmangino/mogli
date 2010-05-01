require "spec_helper"
describe Ogli::Client do
  
  let :client do
    Ogli::Client.new
  end
  
  
  describe "creation" do    
    it "allows creating with an access_token" do
      client = Ogli::Client.new("myaccesstoken")
      client.access_token.should == "myaccesstoken"
    end
  
    it "sets the access_token into the default params" do
      client = Ogli::Client.new("myaccesstoken")
      client.default_params.should == {:access_token=>"myaccesstoken"}
    end

    it "allow creation with no access token" do
      client = Ogli::Client.new
      client.access_token.should be_nil
    end
  
    it "doesn't include the access_token param when not passed" do
      client = Ogli::Client.new
      client.default_params.should == {}
    end
  end
  
  describe "Making requests" do
    
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
      user = client.map_data(user_data,Ogli::User)
      user.should be_an_instance_of(Ogli::User)
      user.id.should == 12451752
    end
    
    it "creates an array of instances when the data is an array" do
      users = client.map_data([user_data,user_data],Ogli::User)
      users.should be_an_instance_of(Array)
      users.each {|i| i.should be_an_instance_of(Ogli::User) }
      users.size.should == 2
    end
    
    it "creates an array of instances when the data is just a hash with a single data parameter" do
      users = client.map_data({"data"=>[user_data,user_data]},Ogli::User)
      users.should be_kind_of(Array)
      users.each {|i| i.should be_an_instance_of(Ogli::User) }
      users.size.should == 2
    end
    
    it "create an instance of fetching array when there is a data element" do
      users = client.map_data({"data"=>[user_data,user_data]},Ogli::User)
      users.should be_an_instance_of(Ogli::FetchingArray)      
    end
    
    it "sets the client on the array" do
      users = client.map_data({"data"=>[user_data,user_data]},Ogli::User)
      users.client.should == client      
    end
    
    it "sets the next url on the array" do
      users = client.map_data({"data"=>[user_data,user_data],"paging"=>{"next"=>"next"}},Ogli::User)
      users.next_url.should == "next"
    end

    it "sets the previous url on the array" do
      users = client.map_data({"data"=>[user_data,user_data],"paging"=>{"previous"=>"prev"}},Ogli::User)
      users.previous_url.should == "prev"
    end
    
    it "sets the classes on the array" do
      users = client.map_data({"data"=>[user_data,user_data],"paging"=>{"previous"=>"prev"}},Ogli::User)
      users.classes.should == [Ogli::User]      
    end
    
    it "sets the client in the newly created instance" do
      user = client.map_data(user_data,Ogli::User)
      user.client.should == client
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
      it "will find the class in the Ogli namespace if given a string" do
        client.create_instance("User",{:id=>1}).should be_an_instance_of(Ogli::User)
      end
      
      it "call the recognize method on each class passing the data and will use the one that recognizes it" do
        Ogli::User.should_receive(:recognize?).with(:id=>1).and_return(false)
        Ogli::Post.should_receive(:recognize?).with(:id=>1).and_return(true)
        client.create_instance(["User","Post"],{:id=>1}).should be_an_instance_of(Ogli::Post)
      end
    end
  end
  
end