
module Mogli
  class User < Model
    
    define_properties :id, :first_name, :last_name, :name, :link, :about, :birthday, 
          :email, :website, :timezone, :updated_time, :verified
    
    def self.recognize?(hash)
      !hash.has_key?("category")
    end
    
    hash_populating_accessor :work, "Work"
    hash_populating_accessor :education, "Education"

    has_association :activities,"Activity"
    has_association :albums,"Album"
    has_association :friends, "User"
    has_association :interests, "Interest"
    has_association :music, "Music"
    has_association :books, "Book"
    has_association :movies, "Movie"
    has_association :television, "Television"
    has_association :posts, "Post"
    has_association :feed, "Post"
  end
end