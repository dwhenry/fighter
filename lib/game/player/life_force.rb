class Game
  class Player
    module LifeForce

      def self.included(base)
        base.send :attr_reader, :hp
      end

      def initialize(*args)
        super
        @hp = 100
      end

      def damage(hp)
        if hp >= @hp
          @hp = 0
          Game::Engine.instance.end('Unfortunately you died.')
        else
          @hp -= hp
        end
      end

      def heal(hp)
        @hp += hp
        return hp if @hp <= 100
        used = hp - (@hp - 100)
        @hp = 100
        used
      end
    end
  end
end