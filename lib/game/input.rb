class Game
  class Input
    def initialize(player)
      @player = player
      @editor = RawLine::Editor.new(STDIN, StringIO.new)

      bind_keys
    end

    def read
      @editor.read
    end

    def bind_keys
      bind_key(:w) { @player.move(:up) }
      bind_key(:s) { @player.move(:down) }
      bind_key(:a) { @player.move(:left) }
      bind_key(:d) { @player.move(:right) }

      @editor.bind(:ctrl_x) { puts "Exiting..."; exit }
    end

    def bind_key(key, &block)
      @editor.terminal.keys[key] = [key.to_s.ord]
      @editor.bind(key) { block.call }
    end
  end
end