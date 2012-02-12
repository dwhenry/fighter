module Render
  class Console
    module DrawMessage
      def draw_message(engine)
        string = "\n\r\n\r"
        string << '  +----------------------------------------+' << "\n\r"
        string << '  +                                        +' << "\n\r"
        string << '  +                Game Over               +' << "\n\r"
        string << '  +  '
        string << ((' ' * 26) + engine.message)[-36..-1]
        string << '  +' << "\n\r"
        string << '  +                                        +' << "\n\r"
        string << '  +----------------------------------------+' << "\n\r"
        string << "\n\r\n\r"

        system('clear')
        @io.puts string
      end
    end
  end
end