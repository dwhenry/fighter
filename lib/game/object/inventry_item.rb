class Game
  class Object
    module InventryItem
      def id
        @options['id'] || raise('Inventry Item must have an ID')
      end

      def name
        @options['name'] || self.class.to_s
      end

      def use
        Game::Player.instance.remove(self)
        true
      end
    end
  end
end
