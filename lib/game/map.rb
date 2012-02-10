class Game
  class Map
    def self.load_map(filename)
      new(filename)
    end

    def initialize(filename)
      file_data = File.read(filename)
      @map_data = JSON.parse(file_data)
      setup_objects
    end

    def setup_objects(objects=@map_data['objects'])
      return unless objects
      objects.each do |object|
        at(object['x'], object['y']).add Game::Object.instance(object['name'])
      end
    end

    def data
      @board ||= build_data
    end

    def [](x)
      data[x]
    end

    def at(x, y)
      data[x][y]
    end

    def method_missing(method, *args, &blk)
      return @map_data[method.to_s] if @map_data.has_key?(method.to_s)
      super
    end

    def start_location
      at(0, 0)
    end

    private
    def build_data
      Game::Location.clear
      map = []
      @map_data['data'].each_with_index do |row, x|
        row_items = []
        row.each_with_index do |location, y|
          row_items << Game::Location.build(location, x, y)
        end
        map << row_items
      end
      map
    end
  end
end