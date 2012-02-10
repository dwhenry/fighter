class Game
  class Player
    attr_reader :location

    def load_map(map)
      @location = map.start_location
      @location.add(self)
    end

    def move(direction)
      new_location = @location.at(direction)
      if new_location.passible?
        @location.remove(self)
        @location = new_location
        @location.add(self)
      else
        # beep or something here
        print "\a"
      end
    end
  end
end