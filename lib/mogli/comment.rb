module Mogli
  class Comment < Model
    
    define_properties :id, :message, :created_time
    creation_properties :message
    hash_populating_accessor :from, "User","Page"
    
  end
end