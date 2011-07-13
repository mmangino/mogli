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

    def self.create(query, app_client)
      app_client.post("accounts/test-users", self, query)
    end

    def self.all(query, app_client)
      app_client.get_and_map("accounts/test-users", self, query)
    end

    def to_s
      id
    end
  end
end
