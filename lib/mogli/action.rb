module Mogli
  class Action < Model
    define_properties :name, :link

    # simple implementation of to_json, ignoring options like :only, :except,
    # :include, :methods because this is primarily intended for being submitted
    # to facebook
    def to_json(options = nil)
      "{\"name\":\"#{name}\",\"link\":\"#{link}\"}"
    end
  end
end
