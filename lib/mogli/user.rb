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
  end
end
