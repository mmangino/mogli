module Mogli
  class Photo < Model
    define_properties :id, :name, :picture, :source, :height, :width, :link, :icon,
      :created_time, :updated_time
    creation_properties :message

    hash_populating_accessor :from, "User","Page"
  end
end
