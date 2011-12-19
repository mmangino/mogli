module Mogli
  class Status < Model
    define_properties :id, :message, :updated_time, :created_time, :likes

    hash_populating_accessor :from, "User", "Page"

    has_association :comments, "Comment"
  end
end
