class Game
  class Tile
    class Edge
      include Game::Tile::Base
      include Game::Tile::Impassible

      def self.instance
        @self ||= new
      end

      def initialize; end
    end
  end
end