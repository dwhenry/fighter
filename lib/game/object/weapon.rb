class Game
  class Object
    module Weapon
      def equip
        Game::Player.instance.equip('weapon', self)
      end

      def use
        tile = player.tile.at(Game::Player.instance.direction)
        if object = tile.objects.detect {|obj| obj.respond_to?(:damage) }
          object.damage(attack)
        end
      end
    end
  end
end
