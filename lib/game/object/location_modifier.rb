class Game
  class Object
    module LocationModifier
      def end_point
        @options['end_point'] || raise('No end point set for location modifier')
      end
    end
  end
end
