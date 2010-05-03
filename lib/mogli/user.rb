
module Mogli
  class User < Hashie::Mash
    include Model
    
    def self.recognize?(hash)
      !hash.has_key?("category")
    end
    
    has_association :activities,"Activity"
    has_association :albums,"Album"
    has_association :friends, "User"
    has_association :interests, "Interest"
    has_association :music, "Music"
    has_association :books, "Book"
    has_association :movies, "Movie"
    has_association :television, "Television"
    has_association :posts, "Post"
  end
end