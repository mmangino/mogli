module Mogli
  class Page < Profile
        
    define_properties :id, :name, :category, :username, :access_token
    
    # General
    define_properties :fan_count, :link, :picture, :has_added_app

    # Retail
    define_properties :founded, :products, :mission, :company_overview
    
    # Musicians
    define_properties :record_label, :hometown, :band_members, :genre
    
	# When "/me/accounts" returns Page with 'access_token', this Page can be
	# impersonated by an application.  The expiration value must be taken from
	# the caller object (e.g., User) so as to uphold the original permissions.
	def initialize(hash = {}, client = nil)
		super(hash, client)
		unless(access_token.blank?)
			if(client.blank?)
				self.client = Mogli::Client.new(access_token)
			else
				self.client =
				Mogli::Client.new(access_token, client.expiration)
			end
		end
	end

    def self.recognize?(hash)
      hash.has_key?("category")
    end
    
  end
end
