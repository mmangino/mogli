module Ogli
  class Comment < Hashie::Dash
    include Model
    
    define_properties :id, :message, :created_time
    
    hash_populating_accessor :from, "User"
    
  end
end