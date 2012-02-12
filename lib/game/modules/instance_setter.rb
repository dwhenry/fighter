class Game
  module Modules
    module InstanceSetter
      def self.included(base)
        base.extend ClassMethods
      end

      def initialize(*args)
        self.class.set(self)
      end

      module ClassMethods
        def set(instance)
          @instance = instance
        end

        def instance
          @instance
        end
      end
    end
  end
end
