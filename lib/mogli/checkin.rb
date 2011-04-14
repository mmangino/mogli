module Mogli
  class Checkin < Model
    define_properties :id,:message, :created_time
    hash_populating_accessor :from, "User"
    hash_populating_accessor :tags, "User"
    hash_populating_accessor :place, "Page"
    hash_populating_accessor :application, "Page"
  end
end
