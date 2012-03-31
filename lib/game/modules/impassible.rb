class Game
  module Modules
    module Impassible
      def passible?(player_objects=[])
        false
      end

      alias :activatable? :passible?
    end
  end
end
