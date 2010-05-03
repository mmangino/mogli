module Mogli
  class Client
    module Event

      
      def event(id)
        get_and_map(id,Mogli::Event)
      end
    end
  end
end
