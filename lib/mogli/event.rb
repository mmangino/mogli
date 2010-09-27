module Mogli
  class Event < Model
    set_search_type
    define_properties :id, :name, :description, :start_time, :end_time, :location, :privacy, :updated_time
    creation_properties :start_time, :end_time, :link, :name, :description, :privacy

    hash_populating_accessor :venue, "Address"
    hash_populating_accessor :owner, "User", "Page"
    has_association :noreply, "User"
    has_association :maybe, "User"
    has_association :invited, "User"
    has_association :attending, "User"
    has_association :declined, "User"
    has_association :feed, "Post"
  end
end
