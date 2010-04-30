module Ogli
  class Client
    module User

      
      def user(id)
        self.class.get(api_path(id))
      end
    end
  end
end