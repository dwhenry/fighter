class Game
  class Tile
    module Movement
      def at(direction)
        tile = Game::Tile.at(@x - 1, @y) if direction == :up
        tile = Game::Tile.at(@x + 1, @y) if direction == :down
        tile = Game::Tile.at(@x, @y - 1) if direction == :left
        tile = Game::Tile.at(@x, @y + 1) if direction == :right

        tile.try(:end_point) || Game::Tile::Edge.instance
      end

      def end_point
        if has_object?(Game::Object::TileModifier)
          Game::Tile.at(*get_object(Game::Object::TileModifier).end_point)
        else
          self
        end
      end
      private :end_point
    end
  end
end