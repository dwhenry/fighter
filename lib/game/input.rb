class Game
  class Input
    def initialize(engine)
      @player = engine.player
      @engine = engine
      @editor = RawLine::Editor.new(STDIN, StringIO.new)
      @keys = {}
      bind_keys
    end

    def read
      system('stty raw -echo') # => Raw mode, no echo
      char = (STDIN.read_nonblock(1).ord rescue nil)
      system('stty -raw echo') # => Reset terminal mode
      @keys[char].call if @keys[char]
    end

    def bind_keys
      bind_key(:w) { @player.move(Game::Map::NORTH) }
      bind_key(:s) { @player.move(Game::Map::SOUTH) }
      bind_key(:a) { @player.move(Game::Map::EAST) }
      bind_key(:d) { @player.move(Game::Map::WEST) }

      bind_key(:W) { @player.move(Game::Map::NORTH) }
      bind_key(:S) { @player.move(Game::Map::SOUTH) }
      bind_key(:A) { @player.move(Game::Map::EAST) }
      bind_key(:D) { @player.move(Game::Map::WEST) }

      bind_key(:' ') { @player.take_action }

      bind_key(:q) { @engine.end('Game terminated') }
      bind_key(:Q) { @engine.end('Game terminated') }

      bind_key(:'1') { skip_to('level9') }
      bind_key(:'2') { skip_to('level6') }
      bind_key(:'3') { skip_to('level7_a') }
      bind_key(:'4') { skip_to('level8') }
      bind_key(:'5') { skip_to('level12') }

      @editor.bind(:ctrl_x) { puts "Exiting..."; exit }
    end

    def bind_key(key, &block)
      @editor.terminal.keys[key] = [key.to_s.ord]
      @editor.bind(key, &block)
      @keys[key.to_s.ord] = block
    end

    private :bind_key

    def skip_to(name)
      @exit ||= Game::Object.instance('SkipExit', 'modules' => ['Exit'])
      @exit.skip_to(name)
    end

    private :skip_to
  end
end
