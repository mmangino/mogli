module Mogli
  class Page < Profile
        
    define_properties :id, :name, :category, :username
    
    # General
    define_properties :fan_count, :link, :picture, :has_added_app

    # Retail
    define_properties :founded, :products, :mission, :company_overview
    
    # Musicians
    define_properties :record_label, :hometown, :band_members, :genre
    
    def self.recognize?(hash)
      hash.has_key?("category")
    end
    
  end
end
