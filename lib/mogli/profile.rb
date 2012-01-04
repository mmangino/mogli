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

    # Facebook's defaults image url, which seems to be the same as square_image_url at this time
    def image_url
      "https://graph.facebook.com/#{id}/picture"
    end

    # 50x50 pixel image url
    def square_image_url
      sized_image_url("square")
    end

    # 50 pixels wide, variable height image url
    def small_image_url
      sized_image_url("small")
    end
    
    # 64.64 pixel image url
    def normal_image_url
      sized_image_url("normal")
    end

    # About 200 pixels wide, variable height image url
    def large_image_url
      sized_image_url("large")
    end
    
    def sized_image_url(size)
      "#{image_url}?type=#{size}"
    end

    def to_s
      name
    end
  end
end
