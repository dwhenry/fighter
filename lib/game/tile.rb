require 'lib/game/tile/base'
require 'lib/game/tile/movement'
require 'lib/game/tile/passible'

require 'lib/game/tile/edge'
require 'lib/game/tile/empty'
require 'lib/game/tile/wall'

class Game
  class Tile
    EMPTY_CELL = 0
    WALL = [
      WALL_90 = 1,
      WALL_CORNER_LEFT = 4,
      WALL_CORNER_RIGHT = 2,
      WALL_CORNER = 5,
      WALL_0 = 3,
      WALL_END = 6,
      WALL_SPOT = 7,
    ].freeze

    class << self
      def build(tile_type, x, y, fog)
        @board ||= {}
        @board[[x, y]] = class_for(tile_type).new(tile_type, x, y, fog)
      end

      def class_for(tile_type)
        case tile_type
        when EMPTY_CELL
          Empty
        when *WALL
          Wall
        else
          raise 'unknown???'
        end
      end

      def clear
        @board = {}
      end

      def at(x, y)
        @board[[x, y]]
      end
    end
  end
end
