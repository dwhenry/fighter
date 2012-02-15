require 'lib/game/player/actions'
require 'lib/game/player/life_force'
require 'lib/game/player/movements'

class Game
  class Player
    include Game::Modules::ObjectManagement
    include Game::Player::Actions
    include Game::Player::Movements
    include Game::Player::LifeForce
    include Game::Modules::InstanceSetter

    attr_accessor :tile
    attr_reader :hp

  end
end