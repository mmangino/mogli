module Mogli
  class Link < Model
    define_properties :link, :message, :id, :name, :page, :created_time, :icon, :picture, :description
    creation_properties :link, :message

    hash_populating_accessor :comments, "Comment"
    hash_populating_accessor :from, "User"
  end
end