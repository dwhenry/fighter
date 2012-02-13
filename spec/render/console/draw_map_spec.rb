require 'spec_helper'

describe Render::Console::DrawMap do
  let(:string_io) { StringIO.new }
  let(:location) { Game::Location.build(Game::Location::EMPTY_CELL, 0, 0) }
  let(:wall_location) { Game::Location.build(Game::Location::WALL_0, 0, 1) }
  let(:player) { mock(:player, :objects => [], :hp => 100, :location => location) }
  let(:engine) { mock(:engine, :map => map, :player => player) }
  let(:map) { mock(:map, :name => 'Test map', :goal => 'pass a test', :data => [[location],[wall_location]]) }
  subject { Render::Console.new(string_io) }

  before do
    subject.stub(:system => true)
  end

  def output(element=nil)
    wall_location.location_type = element if element
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
        output(Game::Location::WALL_90).should include "| | |"
      end

      it 'draws a 0 degree wall' do
        output(Game::Location::WALL_0).should include "|---|"
      end

      it 'draws a right corner wall' do
        output(Game::Location::WALL_CORNER_RIGHT).should include "| +-|"
      end

      it 'draws a left corner' do
        output(Game::Location::WALL_CORNER_LEFT).should include "|-+ |"
      end

      it 'draws a corner' do
        output(Game::Location::WALL_CORNER).should include "|-+-|"
      end
    end

    context 'overwrites a tile with object' do
      let(:exit) { Game::Object.instance("LevelExit", 'modules' => ['Exit']) }
      let(:transport) { Game::Object.instance("RenderTransport", 'modules' => ['LocationModifier']) }
      let(:closed_door) { Game::Object.instance("RenderClosedDoor", 'modules' => ['Passage'], 'passible?' => false)}
      let(:open_door) { Game::Object.instance("RenderClosedDoor", 'modules' => ['Passage'], 'passible?' => true)}
      let(:switcher) { Game::Object.instance("RenderSwitcher", 'modules' => ['Switcher'], 'passible?' => true)}
      let(:setter) { Game::Object.instance("RenderSetter", 'modules' => ['Setter'], 'passible?' => true)}
      let(:trap) { Game::Object.instance("RenderTrap", 'modules' => ['Trap'], 'damage' => 25)}

      it 'when player is on the tile' do
        location.add(Game::Player.new)
        output.should include "| * |"
      end

      it 'when the tile is the exit' do
        location.add(exit)
        output.should include "|EEE|"
      end

      it 'when the tile is the exit and the player is on it' do
        location.add(Game::Player.new)
        location.add(exit)
        output.should include "|E*E|"
      end

      it 'when the tile is a transport' do
        location.add(transport)
        output.should include "|TTT|"
      end

      it 'when the tile is a transport and the player is on it' do
        location.add(Game::Player.new)
        location.add(transport)
        output.should include "|T*T|"
      end

      it 'when the tile is a door' do
        wall_location.add(closed_door)
        output(Game::Location::WALL_0).should include "|DDD|"
      end

      it 'when the tile is an open door' do
        wall_location.add(open_door)
        output(Game::Location::WALL_0).should include "|D D|"
      end

      it 'when the tile is an open door and the player is on it' do
        wall_location.add(Game::Player.new)
        wall_location.add(open_door)
        output(Game::Location::WALL_0).should include "|D*D|"
      end

      it 'when the tile is a switcher' do
        location.add(switcher)
        output.should include "|SSS|"
      end

      it 'when the tile is a switcher and the player is on it' do
        location.add(Game::Player.new)
        location.add(switcher)
        output.should include "|S*S|"
      end

      it 'when the tile is a setter' do
        location.add(setter)
        output.should include "|SSS|"
      end

      it 'when the tile is a switcher and the player is on it' do
        location.add(Game::Player.new)
        location.add(setter)
        output.should include "|S*S|"
      end

      it 'when the tile is a trap' do
        location.add(trap)
        output.should include "|###|"
      end

      it 'when the tile is a trap and the player is on it' do
        location.add(Game::Player.new)
        location.add(trap)
        output.should include "|#*#|"
      end
    end

    context 'player display' do
      it 'displays an inventry header' do
        output.should include "Inventry:"
      end
      it 'displays empty if player has no inventry items' do
        output.should include "(EMPTY)"
      end

      it 'display item names when they exist' do
        player.stub(:objects => [mock(:object, :name => 'Blue Key')])
        output.should include "  1 - Blue Key"
      end
    end
  end
end