module Mogli
  class Address < Model
    
    define_properties :street, :city, :state, :zip, :country, :latitude, :longitude
  end
end