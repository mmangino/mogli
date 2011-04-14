require "mogli/client/event"
require "mogli/client/user"

module Mogli
  class AppClient < Client
    attr_accessor :application_id
    
    def subscription_url
      "https://graph.facebook.com/#{application_id}/subscriptions"
    end
    
    def subscribe_to_model(model,options)
      options_to_send = options.dup
      options_to_send[:fields] = Array(options[:fields]).join(",")
      options_to_send[:object] = name_for_class(model)
      self.class.post(subscription_url,:body=>default_params.merge(options_to_send))
    end
    
    def name_for_class(klass)
      klass.name.split("::").last.downcase
    end
    
    def subscriptions
      get_and_map_url(subscription_url,"Subscription")
    end
  end
end