module Mogli
  class Model
    module Search
      attr_reader :search_type

      def search(pattern="", client=nil, args={})
        raise(NoMethodError.new("Can't search for #{self.to_s}")) unless search_type
        args.merge!({:q => pattern})
        args.merge!(:type => self.search_type) unless search_type == 'all'
        (client||Mogli::Client.new).get_and_map('search', self, args)
      end

      protected

      def set_search_type(type=nil)
        @search_type = type.nil? ? self.to_s.gsub('Mogli::','').downcase : type.to_s
      end

    end
  end
end
