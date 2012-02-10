class Game
  class Object
    class << self
      def instance(name, options={})
        unless const_defined?(name)
          klass = const_set(name, Class.new)
          if options['modules']
            options['modules'].each do |mod|
              klass.send :include, const_get(mod)
            end
          end
        end
        const_get(name).new(options)
      end
    end

    class Exit; end

    module LocationModifier
      def initialize(options)
        @options = options
      end

      def end_point
        @options['end_point'] || raise('No end point set for location modifier')
      end
    end

    module Passage; end
    module InventryItem; end
  end
end
