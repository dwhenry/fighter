require 'spec_helper'

describe Render::Console::DrawMap do
  let(:string_io) { StringIO.new }
  let(:tile) { Game::Tile.build(Game::Tile::EMPTY_CELL, 0, 0) }
  let(:wall_tile) { Game::Tile.build(Game::Tile::WALL_0, 0, 1) }
  let(:player) { mock(:player, :objects => [], :hp => 100, :tile => tile) }
  let(:engine) { mock(:engine, :map => map, :player => player) }
  let(:map) { mock(:map, :name => 'Test map', :goal => 'pass a test', :data => [[tile],[wall_tile]]) }
  subject { Render::Console.new(string_io) }

  before do
    subject.stub(:system => true)
  end

  def output(element=nil)
    wall_tile.tile_type = element if element
    subject.draw_map(engine)

    string_io.rewind
    string_io.read.split("\n\r")
  end

  describe '#draw_map' do
    it 'write the map name' do
      output.should include "Level: Test map"
    end

    it 'write the map goal' do
      output.should include "Goal: pass a test"
    end

    context 'draw Player stats' do
      it 'shows the stats header' do
        output.should include "Player Stats:"
      end

      it 'show the player health' do
        output.should include "  Health:   100"
      end
    end

    context 'draw plain tiles' do
      it 'draws an empty tile' do
        output.should include "|   |"
      end

      it 'draws a 90 degree wall' do
        output(Game::Tile::WALL_90).should include "| | |"
      end

      it 'draws a 0 degree wall' do
        output(Game::Tile::WALL_0).should include "|---|"
      end

      it 'draws a right corner wall' do
        output(Game::Tile::WALL_CORNER_RIGHT).should include "| +-|"
      end

      it 'draws a left corner' do
        output(Game::Tile::WALL_CORNER_LEFT).should include "|-+ |"
      end

      it 'draws a corner' do
        output(Game::Tile::WALL_CORNER).should include "|-+-|"
      end
    end

    context 'overwrites a tile with object' do
      let(:exit) { Game::Object.instance("LevelExit", 'modules' => ['Exit']) }
      let(:transport) { Game::Object.instance("RenderTransport", 'modules' => ['TileModifier']) }
      let(:closed_door) { Game::Object.instance("RenderClosedDoor", 'modules' => ['Passage'], 'passible?' => false)}
      let(:open_door) { Game::Object.instance("RenderClosedDoor", 'modules' => ['Passage'], 'passible?' => true)}
      let(:switcher) { Game::Object.instance("RenderSwitcher", 'modules' => ['Switcher'], 'passible?' => true)}
      let(:setter) { Game::Object.instance("RenderSetter", 'modules' => ['Setter'], 'passible?' => true)}
      let(:trap) { Game::Object.instance("RenderTrap", 'modules' => ['Trap'], 'damage' => 25)}

      it 'when player is on the tile' do
        tile.add(Game::Player.new)
        output.should include "| ^ |"
      end

      it 'when the tile is the exit' do
        tile.add(exit)
        output.should include "|EEE|"
      end

      it 'when the tile is the exit and the player is on it' do
        tile.add(Game::Player.new)
        tile.add(exit)
        output.should include "|E^E|"
      end

      it 'when the tile is a transport' do
        tile.add(transport)
        output.should include "|TTT|"
      end

      it 'when the tile is a transport and the player is on it' do
        tile.add(Game::Player.new)
        tile.add(transport)
        output.should include "|T^T|"
      end

      it 'when the tile is a door' do
        wall_tile.add(closed_door)
        output(Game::Tile::WALL_0).should include "|DDD|"
      end

      it 'when the tile is an open door' do
        wall_tile.add(open_door)
        output(Game::Tile::WALL_0).should include "|D D|"
      end

      it 'when the tile is an open door and the player is on it' do
        wall_tile.add(Game::Player.new)
        wall_tile.add(open_door)
        output(Game::Tile::WALL_0).should include "|D^D|"
      end

      it 'when the tile is a switcher' do
        tile.add(switcher)
        output.should include "|SSS|"
      end

      it 'when the tile is a switcher and the player is on it' do
        tile.add(Game::Player.new)
        tile.add(switcher)
        output.should include "|S^S|"
      end

      it 'when the tile is a setter' do
        tile.add(setter)
        output.should include "|SSS|"
      end

      it 'when the tile is a switcher and the player is on it' do
        tile.add(Game::Player.new)
        tile.add(setter)
        output.should include "|S^S|"
      end

      it 'when the tile is a trap' do
        tile.add(trap)
        output.should include "|###|"
      end

      it 'when the tile is a trap and the player is on it' do
        tile.add(Game::Player.new)
        tile.add(trap)
        output.should include "|#^#|"
      end
    end

    context 'player display' do
      it 'displays an inventry header' do
        output.should include "Inventry:"
      end
      it 'displays empty if player has no inventry items' do
        output.should include "(EMPTY)"
      end

      context 'display item names when they exist' do
        before do
          player.stub(:equiped? => false)
        end

        it 'with highlight when selected item' do
          player.stub(:objects => [mock(:object, :name => 'Blue Key')])
          output.should include "\e[7m  Blue Key     \e[m"
        end

        it 'without highlight when not selected' do
          player.stub(:objects => [mock(:object, :name => 'Blue Key'),
                                   mock(:object, :name => 'Green Key')])
          output.should include "  Green Key    "
        end

        context 'when object is equiped' do
          it 'is marked as equiped' do
            player.stub(:objects => [mock(:object, :name => 'Blue Key', :on => true)],
                        :equiped? => true)
            output.should include "\e[7m  Blue Key     (Equiped)\e[m"
          end
        end
      end
    end
  end
end