module Mogli
  class Place < Page
  
    set_search_type    

    define_properties :phone, :is_community_page, :website, :description

#    define_properties :id, :name, :location, :category

#    has_association :checkins, "Checkin"
    
  end
end
