require "spec_helper"

describe Ogli::Post do
  
  it "populates from as the user from a hash" do
    post = Ogli::Post.new("from"=> {"id" => "12451752", "name" => "Mike Mangino"})
    post.from.should be_an_instance_of(Ogli::User)
    post.from.id.should == "12451752"
    post.from.name.should == "Mike Mangino"
  end
    
  it "populates comments from a hash array" do
    post = Ogli::Post.new ({"comments"=>{"data"=>[{"id"=>1,"message"=>"message1"},{"id"=>2}]}},Ogli::Client.new("my_api_key"))
    post.comments.size.should == 2
    post.comments.each {|c| c.should be_an_instance_of(Ogli::Comment)}
    post.comments.first.id.should == 1
    post.comments.first.client.access_token.should == "my_api_key"
  end
  
end