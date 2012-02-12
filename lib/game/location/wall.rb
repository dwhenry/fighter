class Game
  class Location
    class Wall
      include Game::Modules::ObjectManagement
      include Game::Location::Base
      include Game::Location::Movement

      def passible?(player_objects)
        return false unless has_object?(Game::Object::Passage)
        passage = get_object(Game::Object::Passage)
        return true if passage.passible?
        key = player_objects.detect{|obj| obj.id == passage.id}
        passage.open if key
        key.try(:use)
      end
    end
  end
end