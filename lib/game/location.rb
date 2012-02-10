class Game
  class Location
    attr_accessor :location_type
    attr_reader :objects, :x, :y

    EMPTY_CELL = 0
    WALL_90 = 1
    WALL_CORNER_LEFT = 4
    WALL_CORNER_RIGHT = 2
    WALL_0 = 3

    class << self
      def build(location_type, x, y)
        @board ||= {}
        @board[[x, y]] = class_for(location_type).new(location_type, x, y)
      end

      def class_for(location_type)
        case location_type
        when WALL_0, WALL_90, WALL_CORNER_RIGHT, WALL_CORNER_LEFT
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

    def at(direction)
      tile = self.class.at(@x - 1, @y) if direction == :up
      tile = self.class.at(@x + 1, @y) if direction == :down
      tile = self.class.at(@x, @y - 1) if direction == :left
      tile = self.class.at(@x, @y + 1) if direction == :right

      tile.try(:end_point) || Game::Location::Edge.instance
    end

    def end_point
      if has_object?(Game::Object::LocationModifier)
        self.class.at(*get_object(Game::Object::LocationModifier).end_point)
      else
        self
      end
    end
    private :end_point

    def passible?
      true
    end

    def add(object)
      @objects << object
    end

    def remove(object)
      @objects.delete(object)
    end

    def has_object?(object_class)
      !!@objects.detect { |object| object.is_a?(object_class) }
    end

    def get_object(object_class)
      @objects.detect { |object| object.is_a?(object_class) }
    end

    class Edge < Game::Location
      def self.instance
        @self ||= new
      end

      def initialize; end

      def passible?
        false
      end
    end

    class Wall < Game::Location
      def passible?
        false
      end
    end
  end
end