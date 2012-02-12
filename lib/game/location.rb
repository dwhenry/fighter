require 'lib/game/location/modules'
require 'lib/game/location/wall'
require 'lib/game/location/edge'

class Game
  class Location
    include Game::Modules::ObjectManagement
    include Game::Location::Base
    include Game::Location::Passible
    include Game::Location::Movement

    EMPTY_CELL = 0
    WALL_90 = 1
    WALL_CORNER_LEFT = 4
    WALL_CORNER_RIGHT = 2
    WALL_CORNER = 5
    WALL_0 = 3

    class << self
      def build(location_type, x, y)
        @board ||= {}
        @board[[x, y]] = class_for(location_type).new(location_type, x, y)
      end

      def class_for(location_type)
        case location_type
        when WALL_0, WALL_90, WALL_CORNER_RIGHT,
             WALL_CORNER_LEFT, WALL_CORNER
          Wall
        when EMPTY_CELL
          self
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