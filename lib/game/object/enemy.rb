class Game
  class Object
    module Enemy
      IDLE = :idle

      def passible?
        false
      end

      def status
        IDLE
      end
    end
  end
end
