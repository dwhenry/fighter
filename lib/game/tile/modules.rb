class Game
  class Tile
    module Impassible
      def passible?(player_objects)
        false
      end
    end

    module Passible
      def passible?(player_objects)
        objects.all?(&:passible?)
      end
    end

    module Base
      def self.included(base)
        base.send :attr_accessor, :tile_type
        base.send :attr_reader, :objects, :x, :y
      end

      def initialize(tile_type, x, y)
        @tile_type = tile_type
        @x = x
        @y = y
        @objects = []
      end

      def ==(val)
        tile_type == val.tile_type &&
        x == val.x &&
        y == val.y
      end
    end
  end
end