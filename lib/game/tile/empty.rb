class Game
  class Tile
    class Empty
      include Game::Modules::ObjectManagement
      include Game::Tile::Base
      include Game::Tile::Passible
      include Game::Tile::Movement

    end
  end
end