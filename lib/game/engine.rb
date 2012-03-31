class Game
  class Engine
    include Game::Modules::InstanceSetter

    attr_reader :state, :player, :message

    def initialize
      super
      @state = 'Running'
      @player = Player.new
      load_map Game::Map.load_map('maps/level1')
    end

    def load_map(map)
      @map = map
      @player.load_map @map
    end

    def map
      @map
    end

    def take_turn
      activate_objects

      active_objects = Game::Object.engine_objects(map.name)[Game::Object::ACTIVE]
      active_objects.each {|obj| obj.active_turn }
    end

    def activate_objects
      close_tiles = Game::Player.instance.tile.elements_within(2)
      tile = Game::Player.instance.tile
      close_tiles.each do |tile|
        tile.objects.each do |obj|
          obj.activate if obj.respond_to?(:activate)
        end
      end
    end

    def ended?
      !!@ended
    end

    def end(message)
      @ended = true
      @message = message
    end
  end
end