module Mogli
  class Page < Model
        
    define_properties :id, :name, :category
    
    hash_populating_accessor :albums, "Album"
    hash_populating_accessor :photos, "Photo"
    hash_populating_accessor :feed, "Post"
    hash_populating_accessor :posts, "Post"
    hash_populating_accessor :events, "Event"
    hash_populating_accessor :videos, "Video"
    hash_populating_accessor :founded, "Founded"
    hash_populating_accessor :products, "Products"
    hash_populating_accessor :username, "Username"
    hash_populating_accessor :mission, "Mission"
    hash_populating_accessor :company_overview, "Company Overview"
    hash_populating_accessor :fan_count, "Fan Count"
    hash_populating_accessor :has_added_app, "Has Added App"
    hash_populating_accessor :link, "Link"
    hash_populating_accessor :picture, "Picture"
    
    def self.recognize?(hash)
      hash.has_key?("category")
    end
    
    def to_s
      name
    end
  end
end