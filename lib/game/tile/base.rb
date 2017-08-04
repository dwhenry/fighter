class Game
  class Tile
    module Base
      def self.included(base)
        base.send :attr_accessor, :tile_type, :fog
        base.send :attr_reader, :objects, :x, :y
      end

      def initialize(tile_type, x, y, fog)
        super()
        @tile_type = tile_type
        @x = x
        @y = y
        @objects = []
        @fog = fog
      end

      def ==(val)
        tile_type == val.tile_type &&
        x == val.x &&
        y == val.y
      end
    end
  end
end
