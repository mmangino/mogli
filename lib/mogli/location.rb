module Mogli
  class Location < Model
    define_properties :latitude, :longitude, :street, :city, :state,
                      :country, :zip

  end
end
