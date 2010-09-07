module Mogli
  class Status < Model
    define_properties :id, :message, :updated_time, :created_time

    hash_populating_accessor :from, "User", "Page"
  end
end
