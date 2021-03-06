class Game
  class Player
    module Movements
      def self.included(base)
        base.send :attr_reader, :direction
        base.send :attr_accessor, :tile
      end

      def initialize(*args)
        super
        @direction = Game::Map::NORTH
      end

      def load_map(map)
        @map = map
        @tile = @map.start_tile
        @tile.add(self)
        @map.clear_fog(tile)
      end

      def move(direction)
        @direction = direction
        new_tile = @tile.at(direction)
        if new_tile.passible?(objects)
          move_to new_tile
          take_auto_action
        else
          # beep or something here
          print "\a"
        end
      end

      def move_to(tile)
        @tile.remove(self)
        @tile = tile
        @map.clear_fog(tile)
        @tile.add(self)
      end
    end
  end
end
