class Game
  class Object
    module Passage
      def passible?
        @passible = !!@options['passible?'] unless instance_variable_defined?('@passible')
        @passible
      end

      def open
        @passible = true
      end

      def close
        @passible = false
      end

      def switch
        @passible = !passible?
      end
    end
  end
end
