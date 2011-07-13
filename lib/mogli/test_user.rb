module Mogli
  # Support for Facebook test users, as described here:
  #
  # http://developers.facebook.com/docs/test_users/
  #
  # Test user creation/listing requires an app access token and an app
  # id.
  #
  # Example usage:
  #
  # +Mogli::TestUser.all({}, Mogli::AppClient.new('access_token', 'app_id'))+
  class TestUser < User
    define_properties :access_token, :login_url, :password

    # test_user_params can include:
    #
    # installed: This is a Boolean parameter to specify whether your
    # app should be installed for the test user at the time of
    # creation. It is true by default.
    #
    # name: this is an optional string parameter. You can specify a
    # name for the test user you create. The specified name will also
    # be used in the email address assigned to the test user.
    #
    # permissions: This is a comma-separated list of {extended permissions}[http://developers.facebook.com/docs/reference/api/permissions/].
    # Your app is granted these permissions for the new test user if
    # installed is true.
    #
    # Example usage:
    #
    # Mogli::TestUser.create({:installed => false, :name => 'Zark Muckerberg', :permissions => 'user_events,create_event'}, client)
    def self.create(test_user_params, app_client)
      app_client.post("accounts/test-users", self, test_user_params)
    end

    def self.all(app_client)
      app_client.get_and_map("accounts/test-users", self, {})
    end

    def to_s
      # name is nil by default, so use id
      id.to_s
    end
  end
end
