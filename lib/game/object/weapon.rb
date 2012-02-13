class Game
  class Object
    module Weapon
      def equip
        Game::Player.instance.equip('weapon', self)
      end

      def attack

      end
    end
  end
end
