require 'lib/game/object/selector'

require 'lib/game/object/default'
require 'lib/game/object/Exit'
require 'lib/game/object/inventry_item'
require 'lib/game/object/location_modifier'
require 'lib/game/object/passage'
require 'lib/game/object/switcher'
require 'lib/game/object/setter'
require 'lib/game/object/trap'

class Game
  class Object
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
    end
  end
end
