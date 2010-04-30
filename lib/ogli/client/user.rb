module Ogli
  class Client
    module User

      
      def user(id)
        get_and_map(id,Ogli::User)
      end
    end
  end
end