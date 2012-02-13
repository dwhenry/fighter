class Game
  class Object
    module TileModifier
      def end_point
        @options['end_point'] || raise('No end point set for tile modifier')
      end
    end
  end
end
