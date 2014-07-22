class Game
  class Object
    module Default
      def self.included(base)
        base.send :attr_accessor, :tile, :player
      end

      def initialize(options)
        @options = options
        super()
      end

      def id
        @options['id']
      end

      def method_missing(method, *args, &blk)
        @options.fetch(method.to_s) do
          super
        end
      end

      def respond_to?(method)
        @options.has_key?(method.to_s) || super
      end
    end
  end
end
