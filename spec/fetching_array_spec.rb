require "spec_helper"
describe Mogli::FetchingArray do
  
  let :fetching_array do
    array = Mogli::FetchingArray.new
    array << Mogli::User.new(:id=>4)
    array << Mogli::User.new(:id=>5)
    array.next_url = "https://next"
    array.previous_url = "https://previous"
    array.client = client
    array.classes = [Mogli::User]
    array
  end
  
  let :client do
    Mogli::Client.new
  end
  
  it "has a next_url" do
    fetching_array.next_url.should == "https://next"
  end
  
  it "has a previous url" do
    fetching_array.previous_url.should == "https://previous"    
  end
  
  it "has a client" do
    fetching_array.client.should == client
  end
  
  it "has the classes that it fetches for" do
    fetching_array.classes = ["User"]
    fetching_array.classes.should == ["User"]
  end


  describe "fetching" do
    before(:each) do
      Mogli::Client.stub!(:get).and_return("data"=>[:id=>3],"paging"=>{"previous"=>"https://new_previous","next"=>"https://new_next"})
    end
    
    describe "fetch next" do

      it "returns an empty array if there is no next_url" do
        Mogli::FetchingArray.new.fetch_next.should == []
      end

      it "adds the contents to this container" do
        fetching_array.fetch_next
        fetching_array.should == [Mogli::User.new(:id=>4),Mogli::User.new(:id=>5),Mogli::User.new(:id=>3)]
      end
    
      it "updates the next url with the newly fetched next url" do
        fetching_array.fetch_next
        fetching_array.next_url.should == "https://new_next"
      
      end
      
      it "should not change the previous url" do
        fetching_array.fetch_next
        fetching_array.previous_url.should == "https://previous"
      end
    
      it "returns the new records" do
        fetching_array.fetch_next.should == [Mogli::User.new(:id=>3)]
      end
    
    end
  
    describe "fetch previous" do
    
      it "returns an empty array if there is no previous url" do
        Mogli::FetchingArray.new.fetch_previous.should == []
      
      end
    
      it "adds the contents to this container" do
        fetching_array.fetch_previous
        fetching_array.should == [Mogli::User.new(:id=>3),Mogli::User.new(:id=>4),Mogli::User.new(:id=>5)]
      end
    
      it "updates the previous url with the newly fetched previous url" do
        fetching_array.fetch_previous
        fetching_array.previous_url.should == "https://new_previous"
      end
      
      it "should not change the next url" do
        fetching_array.fetch_previous
        fetching_array.next_url.should == "https://next"
      end
    
      it "returns the new records" do
        fetching_array.fetch_previous.should == [Mogli::User.new(:id=>3)]      
      end
    
    end
  end
end
