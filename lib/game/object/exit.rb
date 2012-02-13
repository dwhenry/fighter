class Game
  class Object
    module Exit
      def auto_process
        if @options['next_map']
          skip_to next_map
          move_to if @options["exit_tile"]
        else
          Game::Engine.instance.end('Congratulations you have Won.')
        end
      end

      def next_map_name
        return 'Game Over' unless @options['next_map']

        @options['next_map'].gsub(/((^| |_)[a-z])/) {|v| v.upcase.gsub('_', ' ')}
      end

      def skip_to(name)
        Game::Engine.instance.load_map Game::Map.load_map("maps/#{name}")
      end

      def move_to
        Game::Player.instance.move_to(Game::Tile.at(*exit_tile))
      end
      private :move_to
    end
  end
end
