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
  
  
  
end