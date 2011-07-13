require "spec_helper"
class TestModel < Mogli::Model
  set_search_type :test_model
  define_properties :id, :other_property, :actions
  creation_properties :other_property, :actions
  has_association :comments, "Comment"

  hash_populating_accessor :from, "User"
  hash_populating_accessor :activities, "Activity"
  hash_populating_accessor :actions, "Action"
end


describe Mogli::Model do

  let :model do
    model = TestModel.new(:id=>1)
    model.client = mock_client
    model
  end

  let :mock_client do
    Mogli::Client.new
  end


  it "allows setting the client" do
    user = Mogli::Model.new
    user.client = "client"
    user.client.should == "client"
  end

  it "has a define properties method" do
    model.respond_to?(:id).should be_true
    model.respond_to?(:other_property).should be_true
  end
  
  it "warns when you try to set invalid properties" do
    lambda do
      TestModel.new(:invalid_property=>1,:id=>2)
    end.should_not raise_error
  end

  it "has a comments attribute which fetches when called" do
    mock_client.should_receive(:get_and_map).with("1/comments","Comment", {}).and_return("comments")
    model.comments.should == "comments"
  end
  
  it "populates associations if available" do
    model = TestModel.new("id"=>1, "comments"=>{"data"=>[{"id"=>1,"message"=>"first"},{"id"=>2,"message"=>"second"}]})
    mock_client.should_receive(:get_and_map).never
    model.comments.size.should == 2
    model.comments.first.id.should == 1
    model.comments.last.message.should == "second"
  end

  it "only fetches activities once" do
    mock_client.should_receive(:get_and_map).once.with("1/comments","Comment", {}).and_return([])
    model.comments
    model.comments
  end

  describe "creation" do

    it "has a create method on associations" do
      mock_client.stub!(:post)
      model.comments_create(Mogli::Activity.new)
    end

    it "posts the params to the client" do
      mock_client.should_receive(:post).with("1/comments","Comment",:message=>"my message")
      model.comments_create(Mogli::Comment.new(:message=>"my message"))
    end

  end

  it "populates from as the user from a hash" do
    model.from = {"id" => "12451752", "name" => "Mike Mangino"}
    model.from.should be_an_instance_of(Mogli::User)
    model.from.id.should == "12451752"
    model.from.name.should == "Mike Mangino"
  end

  it "populates activities from a hash array" do
    model.activities = {"data"=>[{"id"=>1,"name"=>"Coding"},{"id"=>2}]}
    model.activities.size.should == 2
    model.activities.each {|c| c.should be_an_instance_of(Mogli::Activity)}
    model.activities.first.id.should == 1
    model.activities.first.client.should == mock_client
  end

  it "allows deleting the post" do
    mock_client.should_receive(:delete).with(1)
    model.destroy
  end

  it "freezes deleted objects" do
    mock_client.should_receive(:delete).with(1)
    model.destroy
    model.should be_frozen
  end

  it "emits warnings when properties that don't exist are written to" do
    model.should_receive(:warn_about_invalid_property).with("doesnt_exist")
    model.doesnt_exist=1
  end

  describe "Posting" do
    it "knows which properties are posted" do
      TestModel.new(:id=>1,:other_property=>2).post_params.keys.map(&:to_s).sort.should == TestModel.creation_keys.map(&:to_s).sort
    end

    it "includes regular hash properties for posting" do
      TestModel.new(:id=>1,:other_property=>2).post_params[:other_property].should == 2
    end

    it "includes associated properties for posting" do
      actions_data = {:name => 'Action Name', :link => 'http://example.com'}
      new_model = TestModel.new(:id=>1,:other_property=>2,:actions => [actions_data])
      new_model.post_params[:actions].should == "[{\"name\":\"Action Name\",\"link\":\"http://example.com\"}]"
    end

    it "includes associated properties for posting even if Array doesn't have to_json method" do
      actions_data = {:name => 'Action Name', :link => 'http://example.com'}
      actions_data_array = [actions_data]
      actions_data_array.stub!(:respond_to?).with(:to_json).and_return(false)
      actions_data_array.stub!(:respond_to?).with(:code).and_return(false)
      actions_data_array.stub!(:respond_to?).with(:parsed_response).and_return(false)

      new_model = TestModel.new(:id=>1,:other_property=>2,:actions => actions_data_array)
      new_model.post_params[:actions].should == "[{\"name\":\"Action Name\",\"link\":\"http://example.com\"}]"
    end

    it "will allow updating status with no object" do
      mock_client.should_receive(:post).once.with("1/comments",nil,{}).and_return([])
      model.comments_create
    end
  end

  describe "Fetching" do

    it "fetches data for a model with an id " do
      Mogli::Client.should_receive(:get).with("https://graph.facebook.com/1", :query=>{}).and_return({:id=>1,:other_property=>2})
      model.fetch
      model.other_property.should == 2
    end
    it "fetches data and returns itself" do
      Mogli::Client.stub!(:get).and_return({:id=>1,:other_property=>2})
      model.fetch.should == model
    end

    it "raises an exception when there is no id" do
      lambda do
        TestModel.new.fetch
      end.should raise_error(ArgumentError)
    end
  end

  describe "Finding" do

    it "finds many models when id is an Array" do
      Mogli::Client.should_receive(:get).with(
        "https://graph.facebook.com/", :query =>{ :ids => '1,2'}
      ).and_return({
        "1" => { :id => 1 }, "2" => { :id => 2 , :other_property => "Bob"}
      })
      users = TestModel.find([1,2])
      users.should have(2).elements
      users.each {|user| user.should be_instance_of(TestModel)}
      users[1].other_property.should == "Bob"
    end

    it "raises an exeption if id doesn't exist" do
      Mogli::Client.should_receive(:get).with(
        "https://graph.facebook.com/123456", :query => {}
      ).and_return({
        "error"=> {"type"=>"QueryParseException", "message"=>"Some of the aliases you requested do not exist: 123456"}
      })
      lambda do
        TestModel.find(123456)
      end.should raise_error(Mogli::Client::QueryParseException, "Some of the aliases you requested do not exist: 123456")

    end

    it "raises an exception if one from many ids doesn't exist" do
      Mogli::Client.should_receive(:get).with(
        "https://graph.facebook.com/", :query =>{ :ids => '1,123456'}
      ).and_return({
        "error"=> {"type"=>"QueryParseException", "message"=>"Some of the aliases you requested do not exist: 123456"}
      })
      lambda do
        TestModel.find([1,123456])
      end.should raise_error(Mogli::Client::QueryParseException, "Some of the aliases you requested do not exist: 123456")

    end

  end

  describe "Searching" do


    it "search for graph resources if specific class defined search type" do
      client = Mogli::Client.new('123');
      Mogli::Client.should_receive(:get).with(
        "https://graph.facebook.com/search", :query => {:q=> "s", :type => 'test_model', :access_token => "123"}
      ).and_return({
        'data' => [{'id' => 1, 'other_property' => "Test"}]
      })
      results = TestModel.search('s',client)
      results.class.should == Mogli::FetchingArray
      results.first.id.should == 1
    end

    it "search in all resource types when searching in Mogli::Model" do
      client = Mogli::Client.new('123');
      Mogli::Client.should_receive(:get).with(
        "https://graph.facebook.com/search", :query => {:q=> "s", :access_token => "123"}
      ).and_return({
        'data' => [{'id' => 1, 'message' => "status!", 'type' => "status"},
        {'id' => 2, 'email' => "bob@example.org", 'type' => "user"}
      ]})
      results = Mogli::Model.search('s',client)
      results.map(&:class).sort_by(&:to_s).should == [Mogli::Status, Mogli::User]
    end

    it "raises access token error if client is not defined" do
      Mogli::Client.should_receive(:get).with(
        "https://graph.facebook.com/search", :query => {:q=> "s", :type => 'user'}
      ).and_return({
        "error"=> {"type"=>"OAuthUnauthorizedClientException", "message"=>"An access token is required to request this resource."}
      })
      lambda {
        Mogli::User.search('s')
      }.should raise_error(Mogli::Client::OAuthUnauthorizedClientException, "An access token is required to request this resource.")
    end

    it "raises error if class doesn't define search type" do
      lambda {
        Mogli::Album.search("Joe")
      }.should raise_error(NoMethodError, "Can't search for Mogli::Album")
    end

  end

end
