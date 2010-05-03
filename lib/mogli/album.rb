module Mogli
  class Album < Hashie::Dash
    include Model
    
    define_properties :id, :name, :description, :link, :count, :created_time, :updated_time
    
    hash_populating_accessor :from, "User","Page"
    has_association :photos, "Photo"
    has_association :comments, "Comment"
    
  end
end