require 'lib/render/console/draw_map'
require 'lib/render/console/draw_tile'
require 'lib/render/console/draw_message'
require 'lib/render/console/player_inventry'

module Render
  class Console
    include Render::Console::DrawMap
    include Render::Console::DrawMessage
    include Render::Console::PlayerInventry

    def initialize(io=STDOUT)
      @io = io
    end
  end
end