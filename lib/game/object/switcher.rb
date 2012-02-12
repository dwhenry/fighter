class Game
  class Object
    module Switcher
      def self.included(base)
        base.send :include, Game::Object::Selector
      end

      def process
        object_for_id('toggle').each {|obj| obj.switch }
      end
    end
  end
end