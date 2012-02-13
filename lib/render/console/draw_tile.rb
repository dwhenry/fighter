module Render
  class Console
    module DrawMap
      class Tile
        attr_reader :tile

        def initialize(tile)
          @tile = tile
        end

        def draw
          if tile.is_a?(Game::Location::Wall)
            draw_player(draw_wall)
          else
            draw_player(draw_empty)
          end
        end

        def draw_player(base)
          return base unless tile.has_object?(Game::Player)
          base[0] +
          case Game::Player.instance.direction
          when :up
            '^'
          when :down
            'v'
          when :left
            '<'
          when :right
            '>'
          else
            '*'
          end +
          base[2]
        end

        def draw_empty
          {
            Game::Object::Switcher          => 'SSS',
            Game::Object::Setter            => 'SSS',
            Game::Object::Exit              => 'EEE',
            Game::Object::LocationModifier  => 'TTT',
            Game::Object::Trap              => '###',

            Game::Object::Enemy             => '|:P',
            Game::Object::Healer            => '+++',
            Game::Object::Weapon            => '+--'
            }.each do |module_name, tile_piece|

            return tile_piece if tile.has_object?(module_name)
          end

          return 'KKK' if defined?(Game::Object::Key) && tile.has_object?(Game::Object::Key)
          '   '
        end

        def draw_wall
          if tile.has_object?(Game::Object::Passage)
            return 'D D' if tile.passible?([])
            return 'DDD'
          end

          base = {
            Game::Location::WALL_90           => ' | ',
            Game::Location::WALL_CORNER_RIGHT => ' +-',
            Game::Location::WALL_CORNER_LEFT  => '-+ ',
            Game::Location::WALL_0            => '---',
            Game::Location::WALL_CORNER       => '-+-'
          }[tile.location_type] || (debugger)
        end
      end
    end
  end
end