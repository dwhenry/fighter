require 'lib/game/player/actions'
require 'lib/game/player/movements'

class Game
  class Player
    include Game::Modules::ObjectManagement
    include Game::Player::Actions
    include Game::Player::Movements
    include Game::Modules::InstanceSetter

    attr_accessor :location
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

    def heal(hp)
      @hp += hp
      return hp if @hp <= 100
      used = hp - (@hp - 100)
      @hp = 100
      used
    end
  end
end