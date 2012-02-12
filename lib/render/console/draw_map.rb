module Render
  class Console
    module DrawMap
      def draw_map(engine)
        string = ''
        string << draw_refresh
        string << draw_title(engine.map)
        string << draw_board(engine.map.data)
        string << draw_stats(engine.player)
        string << draw_player(engine.player)

        system('clear')
        @io.puts string
      end

      private
      def draw_stats(player)
        string = 'Player Stats:'
        string << "\n\r"
        string << "  Health:   " << ("%3.f" % player.hp) << "\n\r"
        string << "\n\r"
        string
      end

      def draw_refresh
        string = "Refresh Rate: "
        if @last
          string  << ("%3f" % (1 / (Time.now - @last)))
        end
        @last = Time.now
        string
      end


      def draw_title(map)
        string = "\n\r\n\r"
        string << "Level: " << map.name << "\n\r"
        string << "Goal: " << map.goal
        string << "\n\r\n\r"
        string
      end

      def draw_board(board)
        string = "\r+"
        board.each { string << '---'}
        string << "+\n\r"
        board.each do |row|
          string << "|"
          row.each { |location| string << draw_location(location) }
          string << "|\n\r"
        end
        string << "+"
        board.each { string << '---'}
        string << "+\n\r\n\r"
        string
      end

      def draw_player(player)
        string = "Inventry:\n\r"
        if player.objects.empty?
          string << "(EMPTY)"
        else
          player.objects.each_with_index do |object, i|
            string << "%3.f" % (i + 1) << ' - ' << object.name << "\n\r"
          end
        end
        string << "\n\r\n\r"
        string
      end

      def draw_location(location)
        cell = case location.location_type
        when Game::Location::EMPTY_CELL
          '   '
        when Game::Location::WALL_90
          ' | '
        when Game::Location::WALL_CORNER_RIGHT
          ' +-'
        when Game::Location::WALL_CORNER_LEFT
          '-+ '
        when Game::Location::WALL_0
          '---'
        when Game::Location::WALL_CORNER
          '-+-'
        else
          ("   #{location.location_type}")[-2..-1]
        end
        cell = 'SSS' if location.has_object?(Game::Object::Switcher)
        cell = 'SSS' if location.has_object?(Game::Object::Setter)
        cell = 'EEE' if location.has_object?(Game::Object::Exit)
        cell = 'TTT' if location.has_object?(Game::Object::LocationModifier)
        cell = '###' if location.has_object?(Game::Object::Trap)
        if location.has_object?(Game::Object::Passage)
          cell = 'DDD'
          cell[1] = ' ' if location.passible?([])
        end
        cell = 'KKK' if defined?(Game::Object::Key) && location.has_object?(Game::Object::Key)
        cell[1] = '*' if location.has_object?(Game::Player)
        cell
      end
    end
  end
end