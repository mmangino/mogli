module Mogli
  class User < Profile
    set_search_type

    define_properties :first_name, :last_name, :link, :about, :birthday, :gender,
          :email, :website, :timezone, :updated_time, :verified, :political, 
          :relationship_status, :locale, :religion, :quotes

    def self.recognize?(hash)
      !hash.has_key?("category")
    end

    hash_populating_accessor :work, "Work"
    hash_populating_accessor :education, "Education"

    hash_populating_accessor :location, "Page"
    hash_populating_accessor :hometown, "Page"

    has_association :activities, "Activity"
    has_association :friends, "User"
    has_association :interests, "Interest"
    has_association :music, "Music"
    has_association :books, "Book"
    has_association :movies, "Movie"
    has_association :television, "Television"
    has_association :likes, "Page"
    has_association :home, "Post"
    has_association :accounts, "Page"

    attr_reader :extended_permissions

    # raised when asked to check for a permission that mogli doesn't know about
    class UnrecognizedExtendedPermissionException < Exception; end

    # the entire list of extended permissions the user is able to grant the
    # application. the list should be kept in sync with
    # http://developers.facebook.com/docs/authentication/permissions
    ALL_EXTENDED_PERMISSIONS = [
      # publishing permissions
      :publish_stream,
      :create_event,
      :rsvp_event,
      :sms,
      :offline_access,
      :publish_checkins,

      # data permissions
      :user_about_me,
      :user_activities,
      :user_birthday,
      :user_education_history,
      :user_events,
      :user_groups,
      :user_hometown,
      :user_interests,
      :user_likes,
      :user_location,
      :user_notes,
      :user_online_presence,
      :user_photo_video_tags,
      :user_photos,
      :user_relationships,
      :user_relationship_details,
      :user_religion_politics,
      :user_status,
      :user_videos,
      :user_website,
      :user_work_history,
      :email,
      :read_friendlists,
      :read_insights,
      :read_mailbox,
      :read_requests,
      :read_stream,
      :xmpp_login,
      :ads_management,
      :user_checkins,

      # page permissions
      :manage_pages
    ]

    # check if the facebook user has a specific permission. the permission arg
    # is a symbol matching the facebook extended permission names exactly:
    # http://developers.facebook.com/docs/authentication/permissions
    def has_permission?(permission)
      if !ALL_EXTENDED_PERMISSIONS.include? permission
        raise UnrecognizedExtendedPermissionException,
              "The requested permission is not recognized as a facebook extended permission: '#{permission}'"
      end

      if !defined?(@extended_permissions)
        fetch_permissions
      end

      extended_permissions[permission]
    end

    private

    # queries all extended permissions for this user for the current application
    # caches a hash of permission names => boolean indicating if the user has
    # granted the specified permission to this app
    def fetch_permissions
      fql = "SELECT #{ALL_EXTENDED_PERMISSIONS.map(&:to_s).join(',')} " +
            "FROM permissions " +
            "WHERE uid = #{self.id}"
      @extended_permissions = {}
      perms_query_result = client.fql_query(fql).parsed_response.first
      ALL_EXTENDED_PERMISSIONS.each do |perm|
        @extended_permissions[perm] = (perms_query_result[perm.to_s] == 1)
      end
    end

  end
end
