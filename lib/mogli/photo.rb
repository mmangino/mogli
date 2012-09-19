module Mogli
  class Photo < Model
    define_properties :id, :name, :tags, :picture, :source, :height, :width, :images, :link, :icon,
      :created_time, :updated_time, :position, :comments, :likes, :place, :name_tags
    creation_properties :message

    hash_populating_accessor :from, "User","Page"
    hash_populating_accessor :place, "Place"
  end
end
