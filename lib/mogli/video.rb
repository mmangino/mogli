module Mogli
  class Video < Model
    
    define_properties :id, :message, :name, :description, :length, :created_time, :updated_time, :icon, :picture, :embed_html
    
    hash_populating_accessor :from, "User", "Page"
    
    has_association :comments, "Comment"
    
  end
end