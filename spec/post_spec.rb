require "spec_helper"

describe Mogli::Post do
  
  it "populates from as the user from a hash" do
    post = Mogli::Post.new("from"=> {"id" => "12451752", "name" => "Mike Mangino"})
    post.from.should be_an_instance_of(Mogli::User)
    post.from.id.should == "12451752"
    post.from.name.should == "Mike Mangino"
  end
    
  it "populates comments from a hash array" do
    post = Mogli::Post.new ({"comments"=>{"data"=>[{"id"=>1,"message"=>"message1"},{"id"=>2}]}},Mogli::Client.new("my_api_key"))
    post.comments.size.should == 2
    post.comments.each {|c| c.should be_an_instance_of(Mogli::Comment)}
    post.comments.first.id.should == 1
    post.comments.first.client.access_token.should == "my_api_key"
  end
  
  it "knows which attributes are posted" do
    Mogli::Post.new(:message=>1,:picture=>2,:link=>3,:name=>4,:description=>5,:created_time=>6).post_params.should ==
       {:message=>1,:picture=>2,:link=>3,:name=>4,:description=>5}
      
  end
  
  
end