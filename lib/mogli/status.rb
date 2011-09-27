module Mogli
  class Status < Model
    define_properties :id, :message, :updated_time, :created_time, :comments, :likes

    hash_populating_accessor :from, "User", "Page"
  end
end
