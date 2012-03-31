class Game
  class Player
    module Equipment
      def self.included(base)
        base.send :attr_reader
      end

      def initialize(*args)
        super
        @space = Hash.new(2)
      end

      def equip(item)
        if !equiped?(item) && space_for(item)
          equipment(item.on) << item
        end
      end

      def unequip(item)
        if equiped?(item)
          equipment(item.on).delete(item)
        end
      end

      def equiped?(item)
        equipment(item.on).include?(item)
      end

      def space_for(item)
        items_size = equipment(item.on).sum(&:size)
        (@space[item.on] - items_size) >= item.size
      end

      def equipment(on=nil)
        @equipment ||= {}

        return @equipment if on.nil?
        @equipment[on] ||= []
      end
    end
  end
end