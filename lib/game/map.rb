class Game
  class Map
    DIRECTIONS = [
      NORTH = :north,
      SOUTH = :south,
      EAST = :east,
      WEST = :west
    ]

    def self.load_map(filename)
      new(filename)
    end

    def initialize(filename)
      file_data = File.read(filename)
      @map_data = JSON.parse(file_data)
      data
      setup_objects
    end

    def setup_objects(objects=@map_data['objects'])
      return unless objects
      objects.each do |object|
        at(object['x'], object['y']).add Game::Object.instance(object['name'], object['details'] || {})
      end
    rescue
      binding.pry
      puts 'a'
    end

    def data
      @board ||= build_data
    end

    def [](x)
      data[x]
    end

    def at(x, y)
      return nil if x < 0 || y < 0
      data[x] && data[x][y]
    end

    def method_missing(method, *args, &blk)
      return @map_data[method.to_s] if @map_data.has_key?(method.to_s)
      super
    end

    def start_tile
      at(*start_location)
    end

    def start_location
      @map_data['start_location'] || [0, 0]
    end

    def clear_fog(tile)
      (-1..1).each do |offset_y|
        (-1..1).each do |offset_x|
          if offset_x.abs + offset_y.abs <= 2
            t = at(tile.x + offset_x, tile.y + offset_y)
            t && t.fog = false
          end
        end
      end
    end

    private

    def build_data
      Game::Tile.clear
      map = []
      data = if @map_data['data'] == 'generate'
               builder = MapBuilder.new(height, width, start_location)
               @map_data['objects'] = builder.place_objects(@map_data['objects'])
               builder.map
             else
               @map_data['data']
             end
      data.each_with_index do |row, x|
        row_items = []
        row.each_with_index do |tile, y|
          row_items << Game::Tile.build(tile, x, y, !!@map_data['fog_of_war'])
        end
        map << row_items
      end
      map
    end
  end
end
