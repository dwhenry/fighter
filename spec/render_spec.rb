require 'spec_helper'

describe Render::Console do
  let(:string_io) { StringIO.new }
  let(:location) { Game::Location.new(Game::Location::EMPTY_CELL, 0, 0) }
  let(:map) { mock(:map, :name => 'Test map', :goal => 'pass a test', :data => [[location]]) }
  subject { Render::Console.new(string_io) }

  before do
    subject.stub(:system => true)
  end

  def output(element=nil)
    location.location_type = element if element
    subject.draw(map)

    string_io.rewind
    string_io.read
  end

  it 'write the map name' do
    output.should =~ /\rLevel: Test map\n/
  end

  it 'write the map goal' do
    output.should =~ /\rGoal: pass a test\n/
  end

  context 'draw plain tiles' do
    it 'draws an empty tile' do
      output(Game::Location::EMPTY_CELL).should =~ /\n|   |\n/
    end

    it 'draws a 90 degree wall' do
      output(Game::Location::WALL_90).should =~ /\n| | |\n/
    end

    it 'draws a 0 degree wall' do
      output(Game::Location::WALL_0).should =~ /\n|---|\n/
    end

    it 'draws a right corner wall' do
      output(Game::Location::WALL_CORNER_RIGHT).should =~ /\n| +-|\n/
    end

    it 'draws a left corner' do
      output(Game::Location::WALL_CORNER_LEFT).should =~ /\n|-+ |\n/
    end
  end

  context 'overwrites a tile with object' do
    it 'when player is on the tile' do
      location.add(Game::Player.new)
      output.should =~ /\n| * |\n/
    end

    it 'when the tile is the exit' do
      location.add(Game::Object::Exit)
      output.should =~ /\n|EEE|\n/
    end

    it 'when the tile is the exit and the player is on it' do
      location.add(Game::Player.new)
      location.add(Game::Object::Exit)
      output.should =~ /\n|E*E|\n/
    end

    it 'when the tile is a transport' do
      location.add(Game::Object::Exit)
      output.should =~ /\n|TTT|\n/
    end

    it 'when the tile is a transport the player is on it' do
      location.add(Game::Player.new)
      location.add(Game::Object::Exit)
      output.should =~ /\n|T*T|\n/
    end
  end
end