module Render
  class Console
    module DrawMessage
      def draw_message(engine)
        string = "\n\r\n\r"
        string << '  +----------------------------------------+' << "\n\r"
        string << '  +                                        +' << "\n\r"
        string << '  +               Game Over                +' << "\n\r"
        string << '  +  '
        len = ((36 - engine.message.length) / 2).to_i + 1
        string << ((' ' * len) + engine.message + (' ' * len))[0..36]
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