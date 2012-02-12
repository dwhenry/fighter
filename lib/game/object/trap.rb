class Game
  class Object
    module Trap
      def auto_process
        Game::Player.instance.damage(damage)
      end
    end
  end
end