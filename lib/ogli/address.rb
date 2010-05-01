module Ogli
  class Address < Hashie::Dash
    include Model
    
    define_properties :street, :city, :state, :zip, :country, :latitude, :longitude
  end
end