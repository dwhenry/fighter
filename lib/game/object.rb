require 'lib/game/object/selector'
require 'lib/game/object/status'

require 'lib/game/object/default'
require 'lib/game/object/enemy'
require 'lib/game/object/exit'
require 'lib/game/object/healer'
require 'lib/game/object/inventry_item'
require 'lib/game/object/tile_modifier'
require 'lib/game/object/passage'
require 'lib/game/object/switcher'
require 'lib/game/object/setter'
require 'lib/game/object/trap'
require 'lib/game/object/weapon'

class Game
  class Object
    IDLE = :idle
    ACTIVE = :active

    class << self
      def instance(name, options={})
        unless const_defined?(name)
          klass = const_set(name, Class.new)
          klass.send :include, Default
          if options['modules']
            options['modules'].each do |mod|
              klass.send :include, const_get(mod)
            end
          end
        end
        store const_get(name).new(options)
      end

      def store(instance)
        @objects ||= []
        @objects << instance
        instance
      end

      def objects
        @objects ||= []
      end

      def engine_objects(level)
        @game_objects ||= {}
        @game_objects[level] ||= {Game::Object::IDLE => [],
                                  Game::Object::ACTIVE => []}
        @game_objects[level]
      end

      def add(level, status, obj)
        engine_objects(level)[status] << obj
      end

      def remove(level, status, obj)
        engine_objects(level)[status].delete(obj)
      end

      def clear
        @game_objects = {}
        @objects = []
      end
    end
  end
end
