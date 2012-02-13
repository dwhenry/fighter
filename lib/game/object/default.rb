class Game
  class Object
    module Default
      def self.included(base)
        base.send :attr_accessor, :location
      end

      def initialize(options)
        @options = options
      end

      def id
        @options['id']
      end

      def method_missing(method, *args, &blk)
        @options.fetch(method.to_s) do
          super
        end
      end
    end
  end
end
