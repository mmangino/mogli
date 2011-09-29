module Mogli
  class Application < Model

    define_properties :id, :name, :description, :category, :subcategory, :link, :canvas_name

    has_association :feed, "Post"
    has_association :posts, "Post"
    has_association :albums, "Album"
    has_association :insights, "Insight"


  end
end