module Mogli
  class Profile < Model
    define_properties :id, :name

    has_association :feed, "Post"
    has_association :links, "Link"
    has_association :photos, "Photo"
    has_association :groups, "Group"
    has_association :albums,"Album"
    has_association :videos, "Video"
    has_association :notes, "Note"
    has_association :posts, "Post"
    has_association :events, "Event"
    has_association :links, "Link"
    has_association :statuses, "Status"
    has_association :checkins, "Checkin"
    
    hash_populating_accessor :location, "Location"
    def image_url
      "https://graph.facebook.com/#{id}/picture"
    end

    def to_s
      name
    end
  end
end