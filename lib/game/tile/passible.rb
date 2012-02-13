class Game
  class Tile
    module Passible
      def passible?(player_objects)
        objects.all?(&:passible?)
      end
    end
  end
end