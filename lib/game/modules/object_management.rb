class Game
  module Modules
    module ObjectManagement
      def self.included(base)
        base.send :attr_reader, :objects
      end

      def initialize(*args)
        super
        @objects = []
      end

      def add(object)
        if self.is_a?(Game::Player)
          object.player = self if object.respond_to?(:player)
          object.tile = nil
        else
          object.player = nil if object.respond_to?(:player)
          object.tile = self
        end
        @objects << object
      end

      def remove(object)
        object.player = nil if object.respond_to?(:player)
        object.tile = nil
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