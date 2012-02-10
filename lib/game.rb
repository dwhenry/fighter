$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))
require 'lib/render'
require 'lib/game/engine'
require 'lib/game/input'
require 'lib/game/player'
require 'lib/game/map'
require 'lib/game/location'
require 'lib/game/object'
require 'json'
require 'rawline'
require 'ruby-debug'

module TryHelper
  def try(method, *args, &block)
    return nil if self.nil?
    send(method, *args, &block)
  end
end

Object.send :include, TryHelper

class Game
  attr_reader :engine

  def initialize
    @engine = Engine.new
    @render = Render::Console.new
    @inputs = Input.new(@engine.player)
  end

  def play
    Thread.abort_on_exception = true
    threads = []
    threads << run_thread { @render.draw(@engine.map) }
    threads << run_thread(1) { @engine.take_turn }
    threads << run_thread(1) { @inputs.read }
    until @engine.ended?
      sleep 0.01
    end
    threads.each {|thr| Thread.kill(thr) }
    @engine.state
  end

  def run_thread(pause=0.05)
    Thread.new do
      loop do
        yield
        sleep pause unless pause == -1
      end
    end
  end
end
