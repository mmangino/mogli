require "mogli/client/event"
require "mogli/client/user"

module Mogli
  class Client
    attr_reader :access_token
    attr_reader :default_params
    attr_reader :expiration

    include HTTMultiParty
    include Mogli::Client::Event
    include Mogli::Client::User

    class ClientException < Exception; end
    class UnrecognizeableClassError < ClientException; end
    class QueryParseException < ClientException; end
    class OAuthAccessTokenException < ClientException; end
    class OAuthUnauthorizedClientException < ClientException; end
    class OAuthException < ClientException; end
    # represents case that the facebook limit on posts to a feed has been exceeded
    class FeedActionRequestLimitExceeded < ClientException; end
    class SessionInvalidatedDueToPasswordChange < ClientException; end
    class HTTPException < ClientException; end

    def api_path(path)
      "https://graph.facebook.com/#{path}"
    end

    def fql_path
      "https://api.facebook.com/method/fql.query"
    end

    def fql_multiquery_path
      "https://api.facebook.com/method/fql.multiquery"
    end

    def initialize(access_token = nil,expiration=nil)
      @access_token = access_token
      # nil expiration means extended access
      expiration = Time.now.to_i + 10*365*24*60*60 if expiration.nil? or expiration == 0
      @expiration = Time.at(expiration)
      @default_params = @access_token ? {:access_token=>access_token} : {}
    end

    def expired?
      expiration and expiration < Time.now
    end

    def self.create_from_code_and_authenticator(code,authenticator)
      post_data = get(authenticator.access_token_url(code)).parsed_response
      if (response_is_error?(post_data))
        raise_client_exception(post_data)
      end
      parts = post_data.split("&")
      hash = {}
      parts.each do |p| (k,v) = p.split("=")
        hash[k]=CGI.unescape(v)
      end

      if hash["expires"]
        expires = Time.now.to_i + hash["expires"].to_i
      else
        expires = nil
      end

      new(hash["access_token"],expires)
    end

    def self.raise_client_exception(post_data)
      raise_error_by_type_and_message(post_data["error"]["type"], post_data["error"]["message"])
    end

    def self.raise_error_by_type_and_message(type, message)
      if type == 'OAuthException' && message =~ /Feed action request limit reached/
        raise FeedActionRequestLimitExceeded.new(message)
      elsif type == 'OAuthException' && message =~ /The session has been invalidated because the user has changed the password/
        raise SessionInvalidatedDueToPasswordChange.new(message)
      elsif Mogli::Client.const_defined?(type)
        raise Mogli::Client.const_get(type).new(message)
      else
        raise ClientException.new("#{type}: #{message}")
      end
    end

    def self.response_is_error?(post_data)
       post_data.kind_of?(Hash) and
       !post_data["error"].empty?
    end

    def self.create_from_session_key(session_key, client_id, secret)
      authenticator = Mogli::Authenticator.new(client_id, secret, nil)
      access_data = authenticator.get_access_token_for_session_key(session_key)
      new(access_token_from_access_data(access_data),expiration_from_access_data(access_data))
    end

    def self.access_token_from_access_data(access_data)
      return nil if access_data.nil?
      access_data['access_token']
    end

    def self.expiration_from_access_data(access_data)
      return nil if access_data.nil? or access_data['expires'].nil?
      Time.now.to_i + access_data['expires'].to_i
    end

    def self.create_and_authenticate_as_application(client_id, secret)
      authenticator = Mogli::Authenticator.new(client_id, secret, nil)
      access_data = authenticator.get_access_token_for_application
      client = AppClient.new(access_data)
      client.application_id = client_id
      client
    end

    def post(path,klass,body_args)
      data = self.class.post(api_path(path),:body=>default_params.merge(body_args))
      map_data(data,klass)
    end

    def delete(path)
      self.class.delete(api_path(path),:query=>default_params)
    end

    def subscribe_to_model(model,options)
      options_to_send=options.dup
      self.class.post("http://")
    end

    def fql_query(query,klass=nil,format="json")
      data = self.class.post(fql_path,:body=>default_params.merge({:query=>query,:format=>format}))
      return data unless format=="json"
      map_data(data,klass)
    end

    def fql_multiquery(queries)
      data = self.class.post(fql_multiquery_path,:body=>default_params.merge({:queries=>queries.to_json,:format=>"json"}))
      map_data(data)
    end

    def get_and_map(path,klass=nil,body_args = {})
      data = self.class.get(api_path(path),:query=>default_params.merge(body_args))
      data = data.values if body_args.key?(:ids) && !data.key?('error')
      map_data(data,klass)
    end

    def get_and_map_url(url,klass=nil,body_args = {})
      data = self.class.get(url,:query=>default_params.merge(body_args))
      map_data(data,klass)
    end

    def map_data(data,klass=nil)
      raise_error_if_necessary(data)
      hash_or_array = extract_hash_or_array(data,klass)
      hash_or_array = map_to_class(hash_or_array,klass) if klass
      hash_or_array
    end

    #protected

    def extract_hash_or_array(hash_or_array,klass)
      hash_or_array = hash_or_array.parsed_response if hash_or_array.respond_to?(:parsed_response)
      return nil if hash_or_array == false
      return hash_or_array if hash_or_array.nil? or hash_or_array.kind_of?(Array)
      return extract_fetching_array(hash_or_array,klass) if is_fetching_array?(hash_or_array)
      return hash_or_array
    end

    def is_fetching_array?(hash)
      hash.has_key?("data") and hash["data"].instance_of?(Array)
    end

    def extract_fetching_array(hash,klass)
      f = Mogli::FetchingArray.new
      f.concat(hash["data"])
      f.client = self
      f.classes = Array(klass)
      if paging=hash["paging"]
        f.next_url = URI.encode paging["next"] unless paging["next"].nil?
        f.previous_url = URI.encode paging["previous"] unless paging["previous"].nil?
      end
      f
    end

    def map_to_class(hash_or_array,klass)
      return nil if !hash_or_array
      if hash_or_array.kind_of?(Array)
        hash_or_array.map! {|i| create_instance(klass,i)}
      else
        hash_or_array = create_instance(klass,hash_or_array)
      end
    end

    def create_instance(klass,data)
      klass_to_create =  determine_class(klass,data)
      if klass_to_create.nil?
        raise UnrecognizeableClassError.new("unable to recognize klass for #{klass.inspect} => #{data.inspect}")
      end
      klass_to_create.new(data,self)
    end

    def capitalize_if_required(string)
      string.downcase == string ? string.capitalize : string
    end

    def constantize_string(klass)
      klass.is_a?(String) ? Mogli.const_get(capitalize_if_required(klass)) : klass
    end

    def determine_class(klass_or_klasses,data)
      return constantize_string(data['type']) if data.key?('type') && klass_or_klasses == Mogli::Model
      klasses = Array(klass_or_klasses).map { |k| constantize_string(k)}
      klasses.detect {|klass| klass.recognize?(data)} || klasses.first
    end

    def raise_error_if_necessary(data)
      raise HTTPException if data.respond_to?(:code) and data.code != 200 and data.code != 400
      if data.kind_of?(Hash)
        if data.keys.size == 1 and data["error"]
          self.class.raise_error_by_type_and_message(data["error"]["type"], data["error"]["message"])
        end
      end
    end

    def fields_to_serialize
      [:access_token,:default_params,:expiration]
    end

    # Only serialize the bare minimum to recreate the session.
    def marshal_load(variables)#:nodoc:
      fields_to_serialize.each_with_index{|field, index| instance_variable_set("@#{field}", variables[index])}
    end

    # Only serialize the bare minimum to recreate the session.
    def marshal_dump#:nodoc:
      fields_to_serialize.map{|field| send(field)}
    end

    # Only serialize the bare minimum to recreate the session.
    def to_yaml( opts = {} )#nodoc
      YAML::quick_emit(self.object_id, opts) do |out|
        out.map(taguri) do |map|
          fields_to_serialize.each do |field|
            map.add(field, send(field))
          end
        end
      end
    end

  end
end
