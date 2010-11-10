module Mogli
  class Checkin < Model
    define_properties :id, :message, :created_time, :coordinates
    creation_properties :message, :place, :coordinates
    hash_populating_accessor :from, "User"
    hash_populating_accessor :tags, "User"
    hash_populating_accessor :place, "Place"
    hash_populating_accessor :application, "Page"
  end
end
