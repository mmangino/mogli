module Mogli
  class Album < Model
    
    define_properties :id, :name, :description, :location, :cover_photo, :privacy, :link, :count, :created_time, :updated_time
    creation_properties :name, :description
    
    hash_populating_accessor :from, "User","Page"
    has_association :photos, "Photo"
    has_association :comments, "Comment"
    
  end
end
