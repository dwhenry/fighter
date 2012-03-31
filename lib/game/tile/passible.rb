class Game
  class Tile
    module Passible
      def passible?(player_objects=[])
        objects.all?{|obj| !obj.respond_to?(:passible?) || obj.passible? }
      end

      def activatable?
        true
      end
    end
  end
end