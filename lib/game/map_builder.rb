class Game
  class MapBuilder
    class Node
      attr_accessor :top, :bottom, :left, :right, :visited, :steps

      def initialize
        @visited = false
        @steps = nil
      end

      def start
        @visited = true
        @steps = 0
      end

      def visited?(direction)
        cell(direction) && cell(direction).visited
      end

      def wall?(direction)
        !visited?(direction)
      end

      def move(direction)
        cell(direction).tap do |node|
          node.visited = true
          node.steps = steps + 1
        end
      end

      def add_left(node)
        return unless node
        self.left = node
        node.right = self
        add_top(left.top && left.top.right)
      end

      def add_top(node)
        return unless node
        self.top = node
        top.bottom = self
      end

      def dist(node)
        ((x - node.x) * (x - node.x)) + ((y - node.y) * (y - node.y))
      end

      def x
        @x ||= left ? left.x + 1 : 0
      end

      def y
        @y ||= top ? top.y + 1 : 0
      end

      def free(node)
        ([left, right, top, bottom].compact - [node]).none?(&:visited)
      end

      private

      def cell(direction)
        {
          left: left,
          right: right,
          top: top,
          bottom: bottom,
        }.fetch(direction)
      end
    end

    def initialize(height, width, start_location)
      col_node = nil
      @map = Array.new(height) do
        row_node = nil
        Array.new(width) do
          new_node = Node.new
          if row_node
            new_node.add_left(row_node)
            row_node = new_node
          else
            new_node.add_top(col_node)
            row_node = col_node = new_node
          end
        end
      end
      @endpoints = []
      @start_tile = @map[start_location[0]][start_location[1]]
      add_paths
    end

    def map
      map_walls(@map)
    end

    def place_objects(objects)
      objects.map do |object|
        location = next_endpoint
        if location
          object['x'] = location.x
          object['y'] = location.y
        end
        object
      end
    end

    private

    def next_endpoint
      location = @endpoints.sort_by(&:steps)[-5..-1].sample
      @endpoints -= [location]
      location
    end

    def add_paths
      @start_tile.start
      location = @start_tile.move(:right)
      location = location.move(:right)

      branches = [@start_tile]
      terminated = []

      while true do
        action = next_action(branches, location)
        case action
        when :move
          direction = next_direction(location)

          if direction == :blocked
            location = direction
          else
            location = location.move(direction)
          end
        when :branch
          branches << location
          # print "b#{branches.count}"
        when :terminate
          terminated << location
          location = branches.sample
          branches -= [location]
          print "t#{branches.count}"
        else
          location = terminated.pop
          print "X"
          next if location
          # no more moves so we are stuck
          break
        end
      end
    end

    def next_action(branches, location)
      options = []
      options << :terminate if branches.count > 2
      options << :terminate if branches.count > 5

      unless location == :blocked
        options << :move << :move << :move << :move << :move << :move

        closest_branch = branches.sort_by { |b| location.dist(b) }.first

        if closest_branch
          dist = location.dist(closest_branch)
          options << :branch << :branch if dist > 4
          options << :branch << :branch if dist > 6
          options << :branch << :branch if dist > 9
        end
      end

      options.sample
    end

    def map_walls(map)
      map.map.with_index do |row|
        row.map.with_index do |cell|
          if cell.visited
            Game::Tile::EMPTY_CELL
          elsif cell.wall?(:left) && cell.wall?(:right)
            if cell.wall?(:top) || cell.wall?(:bottom)
              Game::Tile::WALL_CORNER
            else
              Game::Tile::WALL_0
            end
          elsif cell.wall?(:right)
            Game::Tile::WALL_CORNER_RIGHT
          elsif cell.wall?(:left)
            Game::Tile::WALL_CORNER_LEFT
          elsif cell.wall?(:top) && cell.wall?(:bottom)
            Game::Tile::WALL_90
          elsif cell.wall?(:top) || cell.wall?(:bottom)
            Game::Tile::WALL_END
          else
            Game::Tile::WALL_SPOT
          end
        end
      end
    end

    def next_direction(location)
      # get a list of moveable locations
      surroundings = []
      %i[left right top bottom].each do |direction|
        node = location.send(direction)
        surroundings << direction if node && node.free(location)
      end
      print "s#{surroundings.count}"
      if surroundings.any?
        surroundings.sample
      else
        @endpoints << location

        :blocked
      end
    end
  end
end
