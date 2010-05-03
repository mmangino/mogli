require "cgi"
module Mogli
  class Authenticator
    attr_reader :client_id, :secret, :callback_url
    
    def initialize(client_id,secret,callback_url)
      @client_id = client_id
      @secret = secret
      @callback_url = callback_url
    end
    
    def authorize_url
      "https://graph.facebook.com/oauth/authorize?client_id=#{client_id}&redirect_uri=#{CGI.escape(callback_url)}"
    end
    
    def access_token_url(code)
      "https://graph.facebook.com/oauth/access_token?client_id=#{client_id}&redirect_uri=#{CGI.escape(callback_url)}&client_secret=#{secret}&code=#{CGI.escape(code)}"
    end
    
  end
end