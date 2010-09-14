module Mogli
  class Event < Model
    define_properties :start_time, :end_time, :name
    creation_properties :start_time, :end_time, :name
    
    hash_populating_accessor :venue, "Address"
    hash_populating_accessor :owner, "User", "Page"
    has_association :noreply, "User"
    has_association :mabye, "User"
    has_association :invited, "User"
    has_association :attending, "User"
    has_association :declined, "User"
    has_association :feed, "Post"
  end
end