module Mogli
  module Model
    def client=(val)
      @client=val
    end
    
    def client
      @client || Mogli::Client.new
    end

    def initialize(hash={},client=nil)
      self.client=client
      super(hash)
    end
    
    def self.included(other)
      other.extend(ClassMethods)
    end

    
    module ClassMethods
      
      
      def define_properties(*args)
        args.each do |arg|
          property arg
        end
      end
      
      def hash_populating_accessor(method_name,*klass)
        define_method "#{method_name}=" do |hash|
          instance_variable_set("@#{method_name}",client.map_data(hash,klass))
        end
        define_method "#{method_name}" do
          instance_variable_get "@#{method_name}"
        end
      end
      
      def has_association(name,klass)
        define_method name do
          if (ret=instance_variable_get("@#{name}")).nil?
            ret = client.get_and_map("/#{id}/#{name}",klass)
            instance_variable_set("@#{name}",ret)
          end
          return ret
        end
      end
      
      def recognize?(data)
        true
      end
      
      def find(id,client=nil)
        (client||Mogli::Client.new).get_and_map(id,self)
      end
    end
  end
end