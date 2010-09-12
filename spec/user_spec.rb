require "spec_helper"
describe Mogli::User do
  
  let :user_1 do
    user_1 = Mogli::User.new(:id=>1)
    user_1.client = mock_client
    user_1
  end
  
  let :mock_client do
    mock("client")
  end
  

  
  it "won't recognize pages" do
    Mogli::User.recognize?("id"=>1,"name"=>"bob","category"=>"fdhsjkfsd")
  end
  
  it "will recognize itself" do
    Mogli::User.recognize?("id"=>1,"name"=>"bob")    
  end
  
  
  describe "Finding" do
    
    it "finds optional fields for a user" do
      Mogli::Client.should_receive(:get).with("https://graph.facebook.com/1",
        :query=>{:fields => [:birthday, :gender]}).and_return({:id=>1, :birthday=>'09/15', :gender => 'male'})
      user = Mogli::User.find(1, nil, :birthday, :gender)
      user.birthday.should == '09/15'
      user.gender.should == 'male'
    end
  
    it "finds a user's friends with optional fields" do
      mock_client.should_receive(:get_and_map).with(
        "1/friends", "User", {:fields => [:birthday, :gender]}).and_return(
        [Mogli::User.new(:id=>2, :birthday=>'09/15', :gender => 'male')])
      friends = user_1.friends(:birthday, :gender)
      friends.size.should == 1
    end
  end
  
end