module Render
  class Console
    module DrawMap
      ITEM_WIDTH = 15

      def draw_map(engine)
        @output = "\e[2J\e[f"
        draw_refresh
        draw_title(engine.map)
        draw_board(engine.map.data)
        draw_stats(engine.player)
        draw_player_inventry(engine.player)
        draw_tile(engine.player.tile)
        draw_enemies(engine.map)

        @io.puts @output
      end

      private

      def append(*strings)
        options = strings.last.is_a?(Hash) ? strings.pop : {}
        @output << if options[:color] == :invert
                     invert(strings.join)
                   else
                     strings.join
                   end
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

      def draw_tile(tile)
        objects = tile.objects.dup
        append "Tile: "
        append "  ", classname_for(tile)
        append "Items: "
        objects.each do |obj|
          draw_object(obj)
        end
        append
      end

      def draw_object(obj)
        append space("Healer:"), obj.health      if obj.is_a?(Game::Object::Healer)
        append space("Trap:"), obj.damage        if obj.is_a?(Game::Object::Trap)
        append space("Exit:"), obj.next_map_name if obj.is_a?(Game::Object::Exit)
        append space("Door:"), 'OPEN'            if obj.is_a?(Game::Object::Passage)
        append space("Door Switch")              if obj.is_a?(Game::Object::Switcher)
        append space("Door Setter")              if obj.is_a?(Game::Object::Setter)
        if obj.is_a?(Game::Object::InventryItem)
          details = [space("Weapon:"), space(classname_for(obj))]
          (details << "Att: #{obj.attack}") if obj.respond_to?(:attack)
          (details << "HP: #{obj.hp}") if obj.respond_to?(:hp)
          append(*details)
        end
      end

      def draw_enemies(map)
        active = Game::Object.engine_objects(map.name)[Game::Object::ACTIVE]
        idle = Game::Object.engine_objects(map.name)[Game::Object::IDLE]
        append "Total Enemies: ", active.size + idle.size
        if active.size > 0
          append "Active Enemies: ", active.size
          active.each do |enemy|
            draw_inventry_object(Game::Player.instance, enemy)
          end
        end
      end

      def classname_for(obj)
        return obj.name if obj.respond_to?(:name)
        obj.class.to_s.split('::').last
      end

      def space(value, size=ITEM_WIDTH)
        return value if value.size > size
        "  #{value}#{' ' * size}"[0..size-1]
      end
    end
  end
end