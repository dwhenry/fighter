require 'lib/game/player/actions'
require 'lib/game/player/movements'

class Game
  class Player
    include Game::Modules::ObjectManagement
    include Game::Player::Actions
    include Game::Player::Movements
    include Game::Modules::InstanceSetter

    attr_reader :location
    attr_reader :objects
    attr_reader :hp

    def initialize
      super
      @objects = []
      @hp = 100
    end

    def damage(hp)
      if hp >= @hp
        @hp = 0
        Game::Engine.instance.end('Unfortunately you died.')
      else
        @hp -= hp
      end
    end
  end
end