class Game
  class MapBuilder
    def initialize(height, width)
      @map = height.times.map do
        width.times.map do
          1
        end
      end
      @end_point = [height - 1, width - 1]
      @endpoints = []
      add_paths
    end

    def map
      map_walls(@map)
    end

    def place_objects(objects)
      objects.map do |object|
        location = next_endpoint
        if location
          object['x'] = location[0]
          object['y'] = location[1]
        end
        object
      end
    end

    private

    def next_endpoint
      location = @endpoints.sort_by(&:last)[-5..-1].sample
      @endpoints -= [location]
      location[0]
    end

    def add_paths
      location = [0, 2]
      @map[0][0] = 0
      @map[0][1] = 0
      @map[0][2] = 0

      branches = [[[0, 0], 0]]
      terminated = []
      steps = 0

      while true do
        action = next_action(branches, location)
        case action
        when :move
          # print 'm'
          location = next_location(location, branches, steps)

          if location != :blocked
            @map[location[0]][location[1]] = 0
            steps += 1
          end
        when :branch
          branches << [location, steps]
          # print "b#{branches.count}"
        when :terminate
          terminated << [location, steps]
          location, steps = *(branches.sample)
          branches.reject! { |b, _| b == location }
          # print "t#{branches.count}"
        else
          location, steps = *(terminated.pop)
          # print "X"
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

        closest_branch = branches.sort_by { |b, _| dist_between(location, b) }.first[0]
        options << :branch << :branch if !closest_branch || dist_between(closest_branch, location) > 4
        options << :branch << :branch if !closest_branch || dist_between(closest_branch, location) > 6
        options << :branch << :branch if !closest_branch || dist_between(closest_branch, location) > 9
      end

      options.sample
    end

    def map_walls(map)
      map.map.with_index do |row, i|
        row.map.with_index do |cell, j|
          if cell == 0
            Game::Tile::EMPTY_CELL
          elsif at(i, j - 1) && at(i, j + 1)
            if at(i + 1, j) || at(i - 1, j)
              Game::Tile::WALL_CORNER
            else
              Game::Tile::WALL_0
            end
          elsif at(i, j + 1)
            Game::Tile::WALL_CORNER_RIGHT
          elsif at(i, j - 1)
            Game::Tile::WALL_CORNER_LEFT
          elsif at(i + 1, j) && at(i - 1, j)
            Game::Tile::WALL_90
          elsif at(i + 1, j) || at(i - 1, j)
            Game::Tile::WALL_END
          else
            Game::Tile::WALL_SPOT
          end
        end
      end
    end

    def next_location(location, branches, steps)
      x, y = *location

      # get a list of moveable locations
      surroundings = []
      surroundings << [x + 1, y] if at(x + 1, y) && at(x + 2, y) && (at(x + 1, y + 1) && at(x + 1, y - 1))
      surroundings << [x - 1, y] if at(x - 1, y) && at(x - 2, y) && (at(x - 1, y + 1) && at(x - 1, y - 1))
      surroundings << [x, y + 1] if at(x, y + 1) && at(x, y + 2) && (at(x + 1, y + 1) && at(x - 1, y + 1))
      surroundings << [x, y - 1] if at(x, y - 1) && at(x, y - 2) && (at(x + 1, y - 1) && at(x - 1, y - 1))

      # print "s#{surroundings.count}"
      if surroundings.any?
        surroundings.sample
      else
        @endpoints << [location, steps]

        :blocked
      end
    end

    def dist_between(a, b)
      ((a[0] - b[0]) * (a[0] - b[0])) + ((a[1] - b[1]) * (a[1] - b[1]))
    end

    def at(x, y)
      return nil if x < 0 || y < 0
      @map[x] && @map[x][y] == 1
    end
  end
end
