module Mogli
  class Comment < Model

    define_properties :id, :message, :created_time, :count, :likes, :can_remove, :message_tags
    creation_properties :message
    hash_populating_accessor :from, "User","Page"

  end
end
