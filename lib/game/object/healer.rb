class Game
  class Object
    module Healer
      def auto_process
        self.health -= Game::Player.instance.heal(health)
        self.location.remove(self) if self.health == 0
      end

      def health
        @health ||= @options['health']
      end

      def health=(val)
        @health = val
      end
    end
  end
end
