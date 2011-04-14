module Mogli
  class Insight < Model
    define_properties :id, :name, :period
    hash_populating_accessor :values, "InsightValue"
  end
end