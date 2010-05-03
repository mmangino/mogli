module Mogli
  class Page < Model
        
    define_properties :id, :name, :category
    
    hash_populating_accessor :albums, "Album"
    hash_populating_accessor :photos, "Photo"
    hash_populating_accessor :feed, "Post"
    hash_populating_accessor :posts, "Post"
    hash_populating_accessor :events, "Event"
    hash_populating_accessor :videos, "Video"
    
    def self.recognize?(hash)
      hash.has_key?("category")
    end
    
    def to_s
      name
    end
  end
end