module Mogli

  # requires read_friendlists permission
  # https://developers.facebook.com/docs/reference/api/FriendList/

  class FriendList < Model
    define_properties :name, :list_type, :id

    has_association :members, "User"
  end
end
