class Game
  class Tile
    class Wall
      include Game::Modules::ObjectManagement
      include Game::Tile::Base
      include Game::Tile::Movement

      def passible?(player_objects=[])
        return false unless has_object?(Game::Object::Passage)
        passage = get_object(Game::Object::Passage)
        return true if passage.passible?

        key = player_objects.detect{|obj| obj.id == passage.id}
        passage.open if key.try(:use)
      end

      alias :activatable? :passible?
    end
  end
end