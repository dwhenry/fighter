module Render
  class Console
    INVERT = "\033[7m"
    CLEAR = "\033[m"

    module PlayerInventry
      def draw_player_inventry(player)
        append "Inventry:"
        if player.objects.empty?
          append "(EMPTY)"
        else
          player.objects.each do |object|
            draw_inventry_object(object)
          end
        end
        append
      end

      def draw_inventry_object(obj)
        @selected ||= obj
        options = @selected == obj ? {:color => :invert} : []
        strings = [space(classname_for(obj))]
        details = []
        details << "Att: #{obj.attack}" if obj.respond_to?(:attack)
        details << "HP:  #{obj.hp}" if obj.respond_to?(:hp)
        strings << '(' << details << ')' unless details.empty?
        append *strings, options
      end

      def select_next
        objects = Game::Player.instance.objects
        index = objects.index[@selected] || -1
        @selected = objects[index + 1] if objects.size > index
      end

      def select_prev
        objects = Game::Player.instance.objects
        index = objects.index[@selected] || -1
        @selected = objects[index - 1] if index > 0
      end

      def invert(value)
        Render::Console::INVERT + value + Render::Console::CLEAR
      end
    end
  end
end
