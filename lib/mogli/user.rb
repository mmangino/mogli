
module Mogli
  class User < Profile
    
    define_properties :first_name, :last_name, :link, :about, :birthday, 
          :email, :website, :timezone, :updated_time, :verified
    
    def self.recognize?(hash)
      !hash.has_key?("category")
    end
    
    hash_populating_accessor :work, "Work"
    hash_populating_accessor :education, "Education"

    has_association :activities,"Activity"
    has_association :friends, "User"
    has_association :interests, "Interest"
    has_association :music, "Music"
    has_association :books, "Book"
    has_association :movies, "Movie"
    has_association :television, "Television"
    has_association :likes, "Page"
    
  end
end