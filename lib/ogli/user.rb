
module Ogli
  class User < Hashie::Mash
    include Model
    
    has_association :activities,Ogli::Activity
    has_association :friends, Ogli::User
    has_association :interests, Ogli::Interest
    has_association :music, Ogli::Music
    has_association :books, Ogli::Book
    has_association :movies, Ogli::Movie
    has_association :television, Ogli::Television
    has_association :posts, Ogli::Post
  end
end