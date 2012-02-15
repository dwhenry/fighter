class Game
  class Player
    module Actions
      def take_action
        objects_to_pick_up.each do |obj|
          tile.remove(obj)
          add(obj)
        end
        objects_to_responding_to(:process).each(&:process)
        weapons.each(&:use)
      end

      def take_auto_action
        objects_to_responding_to(:auto_process).each do |obj|
          obj.auto_process
        end
      end

      def objects_to_pick_up
        tile.objects.select {|obj| obj.is_a?(Game::Object::InventryItem) }
      end
      private :objects_to_pick_up

      def objects_to_responding_to(method)
        tile.objects.select {|obj| obj.respond_to?(method) }
      end
      private :objects_to_responding_to

      def weapons
        objects.select {|obj| obj.is_a?(Game::Object::Weapon) }
      end
      private :weapons
    end
  end
end