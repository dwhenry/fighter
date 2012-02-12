class Game
  class Object
    module Setter
      def self.included(base)
        base.send :include, Game::Object::Selector
      end

      def process
        object_for_id('close').each {|obj| obj.close }
        object_for_id('open').each {|obj| obj.open }
      end
    end
  end
end