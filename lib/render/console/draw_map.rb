module Render
  class Console
    module DrawMap
      def draw_map(engine)
        @output = ''
        draw_refresh
        draw_title(engine.map)
        draw_board(engine.map.data)
        draw_stats(engine.player)
        draw_player(engine.player)
        draw_tile(engine.player.location)

        system('clear')
        @io.puts @output
      end

      private
      def append(*strings)
        @output << strings.join
        @output << "\n\r"
      end

      def draw_stats(player)
        append 'Player Stats:'
        append "  Health:   ", ("%3.f" % player.hp)
        append
      end

      def draw_refresh
        rate = @last ? ("%3f" % (1 / (Time.now - @last))) : ''
        @last = Time.now

        append "Refresh Rate: ", rate
        append
      end


      def draw_title(map)
        append "Level: ", map.name
        append "Goal: ", map.goal
        append
      end

      def draw_board(board)
        edge = ["+", '---' * board.size, "+"]
        append *edge
        board.each do |row|
           append "|",
                  *row.map { |tile| Tile.new(tile).draw },
                  "|"
        end
        append *edge
      end

      def draw_player(player)
        append "Inventry:"
        if player.objects.empty?
          append "(EMPTY)"
        else
          player.objects.each_with_index do |object, i|
            append "%3.f" % (i + 1), ' - ', object.name
          end
        end
        append
      end

      def draw_tile(tile)
        objects = tile.objects.dup
        append "Location: "
        append "  ", tile.class
        append "Items: "
        objects.each do |obj|
          draw_object(obj)
        end
      end

      def draw_object(obj)
        append "  Healer:    ", obj.health if obj.is_a?(Game::Object::Healer)
        append "  Trap:      ", obj.damage if obj.is_a?(Game::Object::Trap)
        append "  Exit:      ", obj.next_map_name if obj.is_a?(Game::Object::Exit)
        append "  Door:      ", 'OPEN' if obj.is_a?(Game::Object::Passage)
        append "  Door Switch" if obj.is_a?(Game::Object::Switcher)
        append "  Door Setter" if obj.is_a?(Game::Object::Setter)
        if obj.is_a?(Game::Object::InventryItem)
          if obj.is_a?(Game::Object::Weapon)
            append "  Weapon:    ", classname_for(obj), '(', obj.attack, ')'
          else
            append "  Item:      ", classname_for(obj)
          end
        end
      end

      def classname_for(obj)
        obj.class.to_s.split('::').last
      end
    end
  end
end