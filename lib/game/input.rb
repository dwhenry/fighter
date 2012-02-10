class Game
  class Input
    def initialize(engine)
      @player = engine.player
      @engine = engine
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

      bind_key(:'1') { @engine.skip_to('level1') }
      bind_key(:'2') { @engine.skip_to('level2') }
      bind_key(:'3') { @engine.skip_to('level3') }
      bind_key(:'4') { @engine.skip_to('level4') }

      @editor.bind(:ctrl_x) { puts "Exiting..."; exit }
    end

    def bind_key(key, &block)
      @editor.terminal.keys[key] = [key.to_s.ord]
      @editor.bind(key) { block.call }
    end
  end
end