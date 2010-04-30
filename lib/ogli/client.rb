require "ogli/client/user"

module Ogli
  class Client
    attr_reader :access_token
    attr_reader :default_params
    
    include HTTParty
    include Ogli::Client::User   
    class UnrecognizeableClassError < Exception; end
    
    def api_path(path)
      "http://graph.facebook.com/#{path}"
    end
    
    def initialize(access_token = nil)
      @access_token = access_token
      @default_params = @access_token ? {:access_token=>access_token} : {}
    end
    
    def get_and_map(path,klass=nil)
      data = self.class.get(api_path(path),:query=>default_params)
      map_data(data,klass)
    end
    
    def map_data(data,klass=nil)
      raise_error_if_necessary(data)
      hash_or_array = extract_hash_or_array(data)
      hash_or_array = map_to_class(hash_or_array,klass) if klass
      hash_or_array
    end
    
    
    #protected
    
    def extract_hash_or_array(hash_or_array)
      return hash_or_array if hash_or_array.nil? or hash_or_array.kind_of?(Array)
      return hash_or_array["data"] if hash_or_array.has_key?("data")
      return hash_or_array
    end
    
    def map_to_class(hash_or_array,klass)
      if hash_or_array.kind_of?(Array)
        hash_or_array = hash_or_array.map {|i| create_instance(klass,i)}
      else
        hash_or_array = create_instance(klass,hash_or_array)
      end
    end
    
    def create_instance(klass,data)
      klass = determine_class(klass,data)
      if klass.nil?
        raise UnrecognizeableClassError.new("unable to recognize klass for #{klass.inspect} => #{data.inspect}")
      end
      klass.new(data,self)
    end
    
    def constantize_string(klass)
      klass.is_a?(String) ? Ogli.const_get(klass) : klass
    end
    
    def determine_class(klass_or_klasses,data)
      klasses = Array(klass_or_klasses).map { |k| constantize_string(k)}
      klasses.detect {|klass| klass.recognize?(data)}
    end
    
    def raise_error_if_necessary(data)
      if data.kind_of?(Hash)
        if data.keys.size == 1 and data["error"]
          type = data["error"]["type"]
          message = data["error"]["message"]
          raise Exception.new("#{type}: #{message}")
        end
      end
    end
  end
end