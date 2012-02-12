class Game
  class Object
    module Exit
      def auto_process
        if @options['next_map']
          skip_to next_map
          move_to if @options["exit_location"]
        else
          Game::Engine.instance.end('Congratulations you have Won.')
        end
      end

      def skip_to(name)
        Game::Engine.instance.load_map Game::Map.load_map("maps/#{name}")
      end

      def move_to
        Game::Player.instance.move_to(Game::Location.at(*exit_location))
      end
      private :move_to
    end
  end
end
