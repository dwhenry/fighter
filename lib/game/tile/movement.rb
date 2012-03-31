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
        directions_to(tile).first
      end

      def elements_within(distance)
        Path.new(self).elements(distance)
      end

      def directions_to(tile)
        Path.new(self, tile).directions
      end

      class Path
        def initialize(start, goal=nil)
          @goal = goal
          @paths = {start => {:distance => 0, :path => []}}
        end

        def directions
          until found_goal do
            return [] unless try_paths { |tile| tile.passible? }
          end
          @paths[@goal][:path]
        end

        def elements(distance)
          (1..distance).each do
            break unless try_paths { |tile| tile.activatable? }
          end
          @paths.keys
        end

        def try_paths(&blk)
          @paths.to_a.map do |location, details|
            Game::Map::DIRECTIONS.map do |direction|
              location.try_path(@paths, direction, details, &blk)
            end.any?
          end.any?
        end

        private
        def found_goal
          !!@paths[@goal]
        end
      end

      def try_path(paths, direction, details)
        tile = at(direction)
        return false unless yield(tile)
        !!tile.try_tile(paths, direction, details)
      end

      def try_tile(paths, direction, details)
        distance = (details[:distance] + 1)
        return false if paths[self] && paths[self][:distance] <= distance
        paths[self] = {:distance => distance, :path => (details[:path].dup + [direction])}
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