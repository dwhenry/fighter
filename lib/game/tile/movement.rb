class Game
  class Tile
    module Movement
      def at(direction)
        tile = Game::Tile.at(@x - 1, @y) if direction == Game::Map::NORTH
        tile = Game::Tile.at(@x + 1, @y) if direction == Game::Map::SOUTH
        tile = Game::Tile.at(@x, @y - 1) if direction == Game::Map::EAST
        tile = Game::Tile.at(@x, @y + 1) if direction == Game::Map::WEST

        tile.try(:end_point) || Game::Tile::Edge.instance
      end

      def direction_to(tile)
        diff_x = x - tile.x
        diff_y = y - tile.y

        if diff_x.abs > diff_y.abs
          diff_x > 0 ? Game::Map::NORTH : Game::Map::SOUTH
        else
          diff_y > 0 ? Game::Map::WEST : Game::Map::EAST
        end
      end

      def in_range?(tile, max=10)
        diff_x = x - tile.x
        diff_y = y - tile.y

        ((diff_x * diff_x) + (diff_y * diff_y)) <= (max * max)
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