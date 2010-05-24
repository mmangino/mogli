module Mogli
  class Page < Profile
        
    define_properties :id, :name, :category
    
    
    def self.recognize?(hash)
      hash.has_key?("category")
    end
    
  end
end