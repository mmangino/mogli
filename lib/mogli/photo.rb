module Mogli
  class Photo < Hashie::Dash
    include Model
    define_properties :id, :name, :picture, :source, :height, :width, :link, :icon,
      :created_time, :updated_time
    
    hash_populating_accessor :from, "User","Page"
  end
end