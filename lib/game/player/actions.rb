class Game
  class Player
    module Actions
      def take_action
        objects_to_pick_up.each do |obj|
          location.remove(obj)
          add(obj)
        end
        objects_to_responding_to(:process).each do |obj|
          obj.process
        end
      end

      def take_auto_action
        objects_to_responding_to(:auto_process).each do |obj|
          obj.auto_process
        end
      end

      def objects_to_pick_up
        location.objects.select {|obj| obj.is_a?(Game::Object::InventryItem) }
      end
      private :objects_to_pick_up

      def objects_to_responding_to(method)
        location.objects.select {|obj| obj.respond_to?(method) }
      end
      private :objects_to_responding_to
    end
  end
end