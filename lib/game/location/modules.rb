class Game
  class Location
    module Movement
      def at(direction)
        tile = Game::Location.at(@x - 1, @y) if direction == :up
        tile = Game::Location.at(@x + 1, @y) if direction == :down
        tile = Game::Location.at(@x, @y - 1) if direction == :left
        tile = Game::Location.at(@x, @y + 1) if direction == :right

        tile.try(:end_point) || Game::Location::Edge.instance
      end

      def end_point
        if has_object?(Game::Object::LocationModifier)
          Game::Location.at(*get_object(Game::Object::LocationModifier).end_point)
        else
          self
        end
      end
      private :end_point
    end

    module Impassible
      def passible?(player_objects)
        false
      end
    end

    module Passible
      def passible?(player_objects)
        true
      end
    end

    module Base
      def self.included(base)
        base.send :attr_accessor, :location_type
        base.send :attr_reader, :objects, :x, :y
      end

      def initialize(location_type, x, y)
        @location_type = location_type
        @x = x
        @y = y
        @objects = []
      end

      def ==(val)
        location_type == val.location_type &&
        x == val.x &&
        y == val.y
      end
    end
  end
end