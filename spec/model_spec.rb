require "spec_helper"
class TestModel < Mogli::Model
  define_properties :id, :other_property
  creation_properties :other_property
  has_association :comments, "Comment"

  hash_populating_accessor :from, "User"
  hash_populating_accessor :activities, "Activity"
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


  it "allow setting the client" do
    user = Mogli::Model.new
    user.client = "client"
    user.client.should == "client"
  end

  it "has a define proeprties method" do
    model.respond_to?(:id).should be_true
    model.respond_to?(:other_property).should be_true
  end

  it "have an comments attribute which fetches when called" do
    mock_client.should_receive(:get_and_map).with("1/comments","Comment", {}).and_return("comments")
    model.comments.should == "comments"
  end

  it "only fetch activities once" do
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

  it "knows which attributes are posted" do
    TestModel.new(:id=>1,:other_property=>2).post_params.should == {:other_property=>2}
  end

  it "will allow updating status with no object" do
    mock_client.should_receive(:post).once.with("1/comments",nil,{}).and_return([])
    model.comments_create
  end

  it "emits warnings when properties that don't exist are written to" do
    model.should_receive(:warn_about_invalid_property).with("doesnt_exist")
    model.doesnt_exist=1
  end

  describe "Fetching" do

    it "fetches data for a model with an id " do
      Mogli::Client.should_receive(:get).with("https://graph.facebook.com/1", :query=>{}).and_return({:id=>1,:other_property=>2})
      model.fetch
      model.other_property.should == 2
    end

    it "raises an exception when there is no id" do
      lambda do
        TestModel.new.fetch
      end.should raise_error(ArgumentError)
    end
  end

end
