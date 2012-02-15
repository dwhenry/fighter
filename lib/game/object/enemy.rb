class Game
  class Object
    module Enemy
      def self.included(base)
        base.send :include, Game::Object::Status
        base.send :include, Game::Modules::Impassible

        base.send :attr_reader, :direction, :hp, :status
      end

      def initialize(*args)
        super
        @direction = Game::Map::NORTH
        @hp = @options['health'] || 100
        @status ||= Game::Object::IDLE
        Game::Object.add(Game::Engine.instance.map.name, status, self)
      end

      def damage(hp)
        activate if status == Game::Object::IDLE

        if hp >= @hp
          @hp = 0
          expire
        else
          @hp -= hp
        end
      end

      def move_to(tile)
        @tile.remove(self)
        @tile = tile
        @tile.add(self)
      end

      def active_turn
        raise 'This should not happen.. only call when status is active..' unless status == Game::Object::ACTIVE
        @direction = player_direction

        if player_in_front?
          Game::Player.instance.damage(attack)
        elsif !player_in_range?
          deactivate
        elsif (tile = @tile.at(@direction)).passible?
          move_to(tile)
        end
      end

      def range
        @options['range'] || 4
      end

      def player_in_range?
        @tile.in_range?(Game::Player.instance.tile, range)
      end
      private :player_in_range?

      def player_in_front?
        @tile.at(@direction).has_object?(Game::Player)
      end
      private :player_in_front?

      def player_direction
        @tile.direction_to(Game::Player.instance.tile)
      end
      private :player_direction
    end
  end
end
