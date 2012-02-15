class Game
  class Tile
    class Edge
      include Game::Modules::ObjectManagement
      include Game::Tile::Base
      include Game::Modules::Impassible

      def self.instance
        @self ||= new
      end

      def initialize
        @objects = []
      end

      # over write the object management implementation as
      # the edge should never have objects
      def add(*args)
        raise 'Attempt to add object off the edge of the map'
      end
    end
  end
end