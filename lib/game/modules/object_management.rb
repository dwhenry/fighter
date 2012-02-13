class Game
  module Modules
    module ObjectManagement
      def add(object)
        object.location = self
        @objects << object
      end

      def remove(object)
        @objects.delete(object)
      end

      def has_object?(object_class)
        !!@objects.detect { |object| object.is_a?(object_class) }
      end

      def get_object(object_class)
        @objects.detect { |object| object.is_a?(object_class) }
      end
    end
  end
end