module Render
  class WriteError < StandardError; end

  class Console
    def initialize(io=STDOUT)
      @io = io
    end

    def draw(map)
      board = map.data
      string = "\n\r\n\r"
      string << "Level: " << map.name << "\n\r"
      string << "Goal: " << map.goal
      string << "\n\r\n\r"
      string << "\r+"
      board.each { string << '---'}
      string << "+\n\r"
      board.each do |row|
        string << "|"
        row.each { |location| string << draw_location(location) }
        string << "|\n\r"
      end
      string << "+"
      board.each { string << '---'}
      string << "+\n\r\n\r"

      system('clear')
      # puts board.inspect
      @io.puts string
      # string.split("\n").each do |line|
      #   @editor.write_line line + "\n"
      # end
    end

    private
    def draw_location(location)
      cell = case location.location_type
      when Game::Location::EMPTY_CELL
        '   '
      when Game::Location::WALL_90
        ' | '
      when Game::Location::WALL_CORNER_RIGHT
        ' +-'
      when Game::Location::WALL_CORNER_LEFT
        '-+ '
      when Game::Location::WALL_0
        '---'
      else
        ("   #{location.location_type}")[-2..-1]
      end
      cell = 'XXX' if defined?(Game::Object::Exit) && location.has_object?(Game::Object::Exit)
      cell = 'TTT' if defined?(Game::Object::Transport) && location.has_object?(Game::Object::Transport)
      cell = 'DDD' if defined?(Game::Object::Door) && location.has_object?(Game::Object::Door)
      cell = 'KKK' if defined?(Game::Object::Key) && location.has_object?(Game::Object::Key)
      cell[1] = '*' if location.has_object?(Game::Player)
      cell
    end
  end
end