class Game
  class Location
    class Empty
      include Game::Modules::ObjectManagement
      include Game::Location::Base
      include Game::Location::Passible
      include Game::Location::Movement

    end
  end
end