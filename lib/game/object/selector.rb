class Game
  class Object
    module Selector
      def object_for_id(option)
        return [] unless @options[option]
        Game::Object.objects.select do |obj|
          @options[option].include?(obj.id)
        end
      end
      private :object_for_id
    end
  end
end