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

  describe "checking extended permissions" do
    before :each do
      # construct a response that will avoid errors: we're just testing query
      @dummy_response = 'dummy response'
      @dummy_response.stub!(:parsed_response).and_return [{}]

      # this HTTParty parsed response is taken directly from an actual fql response
      @valid_response = 'valid response'
      @valid_response.stub!(:parsed_response).and_return [{"publish_stream"=>1, "create_event"=>0, "rsvp_event"=>0, "sms"=>0, "offline_access"=>1, "publish_checkins"=>0, "user_about_me"=>0, "user_activities"=>0, "user_birthday"=>0, "user_education_history"=>0, "user_events"=>0, "user_groups"=>0, "user_hometown"=>0, "user_interests"=>0, "user_likes"=>0, "user_location"=>0, "user_notes"=>0, "user_online_presence"=>0, "user_photo_video_tags"=>0, "user_photos"=>0, "user_relationships"=>0, "user_relationship_details"=>0, "user_religion_politics"=>0, "user_status"=>0, "user_videos"=>0, "user_website"=>0, "user_work_history"=>0, "email"=>1, "read_friendlists"=>0, "read_insights"=>0, "read_mailbox"=>0, "read_requests"=>0, "read_stream"=>0, "xmpp_login"=>0, "ads_management"=>0, "user_checkins"=>0, "manage_pages"=>0}]

      @request_regexp = /^SELECT ([\w,]*) FROM permissions WHERE uid = \d*$/
    end

    it "sends FQL with correct syntax when querying permissions" do
      user_1.client.should_receive(:fql_query).with(@request_regexp).and_return @dummy_response
      user_1.send :fetch_permissions
    end

    it "includes all known permissions in FQL query" do
      user_1.client.should_receive(:fql_query) do |query|
        @request_regexp =~ query
        permissions_list = $1

        Mogli::User::ALL_EXTENDED_PERMISSIONS.each do |perm|
          permissions_list.should match /,?#{perm.to_s},?/
        end

        @dummy_response # stubbed return val
      end

      user_1.send :fetch_permissions
    end

    it "only submits permissions-checking FQL once when checking a permission" do
      user_1.client.should_receive(:fql_query).once.and_return @dummy_response
      user_1.has_permission? :publish_stream
      user_1.has_permission? :offline_access
    end

    it "correctly converts FQL response into the permissions hash" do
      user_1.client.should_receive(:fql_query).and_return @valid_response
      user_1.send :fetch_permissions
      Mogli::User::ALL_EXTENDED_PERMISSIONS.each do |perm|
        user_1.extended_permissions.should be_include perm
      end
    end

    it "correctly reports that user has permission they have granted" do
      user_1.client.should_receive(:fql_query).and_return @valid_response
      user_1.should be_has_permission(:offline_access)
    end

    it "correctly reports that user does not have permission they have not granted" do
      user_1.client.should_receive(:fql_query).and_return @valid_response
      user_1.should_not be_has_permission(:manage_pages)
    end

    it "should raise exception on unrecognized permission" do
      lambda {
        user_1.has_permission? :not_a_permission
      }.should raise_error(Mogli::User::UnrecognizedExtendedPermissionException)
    end
  end

end
