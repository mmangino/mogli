module Mogli
  class Action < Model
    define_properties :name, :link

    def to_json
      "{\"name\":\"#{name}\",\"link\":\"#{link}\"}"
    end
  end
end
