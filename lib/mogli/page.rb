module Mogli
  class Page < Profile
    set_search_type

    define_properties :id, :name, :category, :username, :access_token

    # General
    define_properties :fan_count, :link, :picture, :has_added_app, :description, :can_post, :website
    
    # November 2010 migration : fan_count is replaced by likes. 
    # This migration is default for all new application since December 
    # 10th 2010 and will be enabled for all application on February 10th
    # 2011. Since then, it's better to support both.
    define_properties :likes

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
