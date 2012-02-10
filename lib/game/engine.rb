class Game
  class Engine
    attr_reader :state, :player

    def initialize
      @map = Game::Map.load_map('maps/level1')
      @state = 'Running'
      @player = Player.new
      @player.load_map(@map)
    end

    def map
      @map
    end

    def take_turn
      if @player.location.has_object?(Game::Object::Exit)
        begin
          @map = Game::Map.load_map("maps/#{@map.next}")
          @player.load_map(@map)
        rescue NoMethodError
          @ended = true
        end
      end
    end

    def ended?
      !!@ended
    end
  end
end