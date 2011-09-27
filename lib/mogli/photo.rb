module Mogli
  class Photo < Model
    define_properties :id, :name, :tags, :picture, :source, :height, :width, :images, :link, :icon,
      :created_time, :updated_time, :position, :comments, :likes
    creation_properties :message

    hash_populating_accessor :from, "User","Page"
  end
end
