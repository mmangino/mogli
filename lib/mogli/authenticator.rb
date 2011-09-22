require "cgi"
require 'mogli/client'

module Mogli
  class Authenticator
    attr_reader :client_id, :secret, :callback_url

    def initialize(client_id,secret,callback_url)
      @client_id = client_id
      @secret = secret
      @callback_url = callback_url
    end

    def authorize_url(options = {})
      options_part = "&" + options.map {|k,v| "#{k}=#{v.kind_of?(Array) ? v.join(',') : v}" }.join('&') unless options.empty?
      "https://graph.facebook.com/oauth/authorize?client_id=#{client_id}&redirect_uri=#{CGI.escape(callback_url)}#{options_part}"
    end

    def access_token_url(code)
      "https://graph.facebook.com/oauth/access_token?client_id=#{client_id}&redirect_uri=#{CGI.escape(callback_url) unless callback_url.nil? || callback_url.empty?}&client_secret=#{secret}&code=#{CGI.escape(code)}"
    end

    def get_access_token_for_session_key(session_keys)
      keystr = session_keys.is_a?(Array) ?
                 session_keys.join(',') : session_keys
      client = Mogli::Client.new
      response = client.class.post(client.api_path("oauth/exchange_sessions"),
        :body => {
          :type => 'client_cred',
          :client_id => client_id,
          :client_secret => secret,
          :sessions => keystr
        }
      )
      raise_exception_if_required(response)
      tokens = response.parsed_response
      session_keys.is_a?(Array) ? tokens : tokens.first
    end

    def get_access_token_for_application
      client = Mogli::Client.new
      response = client.class.post(client.api_path('oauth/access_token'),
        :body=> {
          :grant_type => 'client_credentials',
          :client_id => client_id,
          :client_secret => secret
        }
      )
      raise_exception_if_required(response)
      response.parsed_response.split("=").last
    end

    def raise_exception_if_required(response)
      raise Mogli::Client::HTTPException if response.code != 200
    end

  end
end
