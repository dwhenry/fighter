class Game
  class Location
    class Edge
      include Game::Location::Base
      include Game::Location::Impassible

      def self.instance
        @self ||= new
      end

      def initialize; end
    end
  end
end