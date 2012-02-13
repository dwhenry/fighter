class Game
  class Player
    module Movements
      def self.included(base)
        base.send :attr_reader, :direction
      end

      def load_map(map)
        @map = map
        @location = @map.start_location
        @location.add(self)
      end

      def move(direction)
        @direction = direction
        new_location = @location.at(direction)
        if new_location.passible?(objects)
          move_to new_location
          take_auto_action
        else
          # beep or something here
          print "\a"
        end
      end

      def move_to(location)
        @location.remove(self)
        @location = location
        @location.add(self)
      end
    end
  end
end