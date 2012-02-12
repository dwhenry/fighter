require 'lib/render/console/draw_map'
require 'lib/render/console/draw_message'

module Render
  class Console
    include Render::Console::DrawMap
    include Render::Console::DrawMessage

    def initialize(io=STDOUT)
      @io = io
    end
  end
end