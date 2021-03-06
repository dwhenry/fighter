$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))
require 'lib/game/modules'

require 'lib/render'
require 'lib/game/engine'
require 'lib/game/input'
require 'lib/game/player'
require 'lib/game/map'
require 'lib/game/map_builder'
require 'lib/game/tile'
require 'lib/game/object'

require 'json'
require 'rawline'

require 'pry'

class Game
  attr_reader :engine

  def initialize
    @engine = Engine.new
    @render = Render::Console.new
    @inputs = Input.new(@engine)
  end

  def play
    Thread.abort_on_exception = true
    threads = []
    threads << run_thread(0.01) { @render.draw_map(@engine) }
    threads << run_thread(1) { @engine.take_turn }
    threads << run_thread { @inputs.read }
    until @engine.ended?
      sleep 0.01
    end
    threads.each {|thr| Thread.kill(thr) }
    @render.draw_message(@engine)
  end

  def run_thread(pause=0.03)
    Thread.new do
      loop do
        yield
        sleep pause unless pause == -1
      end
    end
  end
end
