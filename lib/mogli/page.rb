module Mogli
  class Page < Hashie::Dash
        
    include Model
    define_properties :id, :name, :category
    
    hash_populating_accessor :albums, "Album"
    hash_populating_accessor :photos, "Photo"
    
    def self.recognize?(hash)
      hash.has_key?("category")
    end
    
  end
end