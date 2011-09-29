require 'multi_json'
require 'json'

module Mogli
  class Post < Model

    define_properties :id, :to, :message, :picture, :link, :name, :caption,
      :description, :source, :icon, :attribution, :actions, :likes,
      :created_time, :updated_time, :privacy, :type, :object_id, :properties

    creation_properties :message, :picture, :link, :name, :description, :caption, :source, :actions, :privacy

    hash_populating_accessor :actions, "Action"
    has_association :comments, "Comment"
    hash_populating_accessor :from, "User"
    hash_populating_accessor :application, "Application"

    def likes_create
      client.post("#{id}/likes",nil,{})
    end
  end
end
