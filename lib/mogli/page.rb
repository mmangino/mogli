module Mogli
  class Page < Profile
        
    define_properties :id, :name, :category, :founded, :products, :username, 
      :mission, :company_overview, :fan_count, :has_added_app, :link, :picture
    
    hash_populating_accessor :albums, "Album"
    hash_populating_accessor :photos, "Photo"
    hash_populating_accessor :feed, "Post"
    hash_populating_accessor :posts, "Post"
    hash_populating_accessor :events, "Event"
    hash_populating_accessor :videos, "Video"
    
    def self.recognize?(hash)
      hash.has_key?("category")
    end
    
  end
end