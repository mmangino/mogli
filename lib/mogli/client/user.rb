module Mogli
  class Client
    module User

      
      def user(id)
        get_and_map(id,Mogli::User)
      end
    end
  end
end