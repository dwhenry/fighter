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

      bind_key(:' ') { @player.take_action }

      bind_key(:'1') { skip_to('level5') }
      bind_key(:'2') { skip_to('level6') }
      bind_key(:'3') { skip_to('level7_a') }
      bind_key(:'4') { skip_to('level4') }

      @editor.bind(:ctrl_x) { puts "Exiting..."; exit }
    end

    def bind_key(key, &block)
      @editor.terminal.keys[key] = [key.to_s.ord]
      @editor.bind(key) { block.call }
    end
    private :bind_key

    def skip_to(name)
      @exit ||= Game::Object.instance('SkipExit', 'modules' => ['Exit'])
      @exit.skip_to(name)
    end
    private :skip_to
  end
end