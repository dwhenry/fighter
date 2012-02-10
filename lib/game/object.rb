class Game
  class Object
    class << self
      def instance(name, options={})
        unless const_defined?(name)
          if parent = options['parent']
            const_set(name, Class.new(const_get(parent)))
          else
            const_set(name, Class.new)
          end
        end
        const_get(name).new(options)
      end
    end

    class Exit; end

    class LocationModifier
      def initialize(options)
        @options = options
      end

      def end_point
        @options['end_point'] || raise('No end point set for location modifier')
      end
    end
  end
end
