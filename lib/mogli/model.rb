require 'mogli/model/search'

module Mogli
  class Model  
    extend Mogli::Model::Search

    set_search_type :all

    attr_accessor :type

    def client=(val)
      @client=val
    end

    def client
      @client || Mogli::Client.new
    end

    def initialize(hash={},client=nil)
      @_values = {}
      self.client=client
      hash.each do |k,v|
        self.send("#{k}=",v)
      end
    end

    def post_params
      post_params = {}
      self.class.creation_keys.each do |key|
        post_params[key] =  @_values[key.to_s]

        # make sure actions and any other creation_properties that aren't just
        # hash entries get added...
        if post_params[key].nil? && self.respond_to?(key.to_sym) && !(val=self.send(key.to_sym)).nil?
           post_params[key] = if val.is_a?(Array)
                                "[#{val.map { |v| v.respond_to?(:to_json) ? v.to_json : nil }.compact.join(',')}]"  
                             elsif val.respond_to?(:to_json)
                               val.to_json
                             else
                               nil
                             end
        end
      end

      post_params
    end

    def destroy
      client.delete(id)
      freeze
    end

    def self.included(other)
      other.extend(ClassMethods)
    end

    def method_missing(method, *args)
      method_as_s = method.to_s
      if method_as_s.to_s[-1].chr == "="
        warn_about_invalid_property(method_as_s.chop)
      else
        super
      end
    end
    def warn_about_invalid_property(property)
      puts "Warning: property #{property} doesn't exist for class #{self.class.name}"
    end

    def self.property(arg)
      @properties ||= []
      @properties << arg
      define_method arg do
        @_values[arg.to_s]
      end
      define_method "#{arg}=" do |val|
        @_values[arg.to_s] = val
      end
    end
    
        

    def self.define_properties(*args)
      args.each do |arg|
        property arg
      end
    end

    def self.creation_properties(*args)
      @creation_properties = args
    end

    def self.creation_keys
      @creation_properties || []
    end

    def self.hash_populating_accessor(method_name,*klass)
      define_method "#{method_name}=" do |hash|
        instance_variable_set("@#{method_name}",client.map_data(hash,klass))
      end
      define_method "#{method_name}" do
        instance_variable_get "@#{method_name}"
      end

      add_creation_method(method_name,klass)

    end

    def self.add_creation_method(name,klass)
      define_method "#{name}_create" do |*args|
        arg = args.first
        params = arg.nil? ? {} : arg.post_params
        klass_to_send = arg.nil? ? nil : klass
        client.post("#{id}/#{name}", klass_to_send, params)
      end
    end

    def self.has_association(name,klass)
      define_method name do |*fields|
        body_args = fields.empty? ? {} : {:fields => fields}
        if (ret=instance_variable_get("@#{name}")).nil?
          ret = client.get_and_map("#{id}/#{name}",klass, body_args)
          instance_variable_set("@#{name}",ret)
        end
        return ret
      end
      define_method "#{name}=" do |value|
        instance_variable_set("@#{name}",client.map_to_class(client.extract_hash_or_array(value,klass),klass))
      end

      add_creation_method(name,klass)
    end

    def fetch()
      raise ArgumentError.new("You cannot fetch models without a populated id attribute") if id.nil?
      other = self.class.find(id,client)
      merge!(other) if other
      self
    end
    
    def ==(other)
      other.is_a?(Model) and self.id == other.id
    end
    
    def merge!(other)
      @_values.merge!(other.instance_variable_get("@_values"))
    end
    
    def self.recognize?(data)
      true
    end

    def self.find(id,client=nil, *fields)
      body_args = fields.empty? ? {} : {:fields => fields.join(',')}
      (id, body_args[:ids] = "", id.join(',')) if id.is_a?(Array)
      (client||Mogli::Client.new).get_and_map(id,self, body_args)
    end

  end
end
