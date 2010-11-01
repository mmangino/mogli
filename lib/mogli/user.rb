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


    # allows querying facebook to see if the user has granted the specified
    # permissions. the permissions arg should be an array of strings or
    # symbols matching the facebook permissions exactly:
    # http://developers.facebook.com/docs/authentication/permissions
    #
    # returns a hash from permissions to booleans indicating presence or
    # absence of permission
    def check_permissions(permissions)
      fql = "SELECT #{permissions.map(&:to_s).join(',')} " +
            "FROM permissions " +
            "WHERE uid = #{self.id}"

      result = client.fql_query(fql).parsed_response.first

      result.each_pair do |perm, val|
        result[perm] = (val == 1)
      end
    end


    # check if the facebook user has a specific permission
    # the permission arg should be a string or symbol matching the facebook
    # permissions exactly:
    # http://developers.facebook.com/docs/authentication/permissions
    def has_permission?(permission)
      check_permissions([permission])[permission]
    end
  end
end
