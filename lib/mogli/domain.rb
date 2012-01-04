module Mogli
  class Domain < Model
    define_properties :id, :name, :type
    has_association :insights, "Insight"
  end
end