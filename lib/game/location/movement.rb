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
  end
end