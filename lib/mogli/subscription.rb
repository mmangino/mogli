module Mogli
  class Subscription < Model
    define_properties :callback_url, :fields, :active, :object
  end
end
