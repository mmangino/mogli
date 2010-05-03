module Mogli
  class Post < Hashie::Dash
        
    include Model
    define_properties :id, :to, :message, :picture, :link, :name, :caption, 
      :description, :source, :icon, :attribution, :actions, :likes,
      :created_time, :updated_time
    
    hash_populating_accessor :actions, "Action"
    hash_populating_accessor :comments, "Comment"
    hash_populating_accessor :from, "User"
  end
end