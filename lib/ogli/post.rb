module Ogli
  class Post < Hashie::Dash
    
    def self.recognize?(hash)
      hash.has_key?("category")
    end
    
    include Model
    define_properties :id, :to, :message, :picture, :link, :name, :caption, 
      :description, :source, :icon, :attribution, :actions, :likes,
      :created_time, :updated_time
    
    hash_populating_accessor :actions, "Action"
    hash_populating_accessor :comments, "Comment"
    hash_populating_accessor :from, "User"
  end
end