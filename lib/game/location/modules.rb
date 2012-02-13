class Game
  class Location
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