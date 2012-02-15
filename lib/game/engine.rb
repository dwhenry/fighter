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
      active_objects = Game::Object.engine_objects(map.name)[Game::Object::ACTIVE]
      active_objects.each {|obj| obj.active_turn }
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