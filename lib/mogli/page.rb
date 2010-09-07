module Mogli
  class Page < Profile
    set_search_type

    define_properties :id, :name, :category, :username, :access_token

    # General
    define_properties :fan_count, :link, :picture, :has_added_app

    # Retail
    define_properties :founded, :products, :mission, :company_overview

    # Musicians
    define_properties :record_label, :hometown, :band_members, :genre

    # As a like
    define_properties :created_time

    def client_for_page
      if access_token.blank?
        raise MissingAccessToken.new("You can only get a client for this page if an access_token has been provided. i.e. via /me/accounts")
      end
      Client.new(access_token)
    end

    def self.recognize?(hash)
      hash.has_key?("category")
    end

    class MissingAccessToken < Exception
    end

  end

end
