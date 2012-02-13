require 'spec_helper'

describe Game::Tile::Wall do
  describe '#passible?' do
    subject { Game::Tile::Wall.new(0, 0, 0) }
    let(:passage) { Game::Object.instance('TestWallPassage', 'modules' => ['Passage'], 'passible?' => false, 'id' => 'door_key') }
    let(:key) { Game::Object.instance('TestWallPassageKey', 'modules' => ['InventryItem'], 'id' => 'door_key') }

    before do
      key.stub(:use => true)
    end

    it 'false by default' do
      subject.should_not be_passible([])
    end

    it 'true if you hold the key to a passage way' do
      subject.add(passage)
      subject.should be_passible([key])
    end

    it 'uses the key' do
      subject.add(passage)
      key.should_receive(:use)
      subject.passible?([key])
    end

    context 'initial is set based on the passible flag in the options' do
      it 'when false' do
        subject.add(passage)
        subject.should_not be_passible([])
      end

      it 'when true' do
        passage = Game::Object.instance('OpenTestWallPassage', 'modules' => ['Passage'], 'passible?' => true, 'id' => 'door_key')
        subject.add(passage)
        subject.should be_passible([])
      end
    end
  end

  describe 'feature testing' do
    let(:start) { Game::Tile.build(0, 0, 0) }
    let(:wall) { Game::Tile.build(Game::Tile::WALL_0, 1, 0) }
    let(:stop) { Game::Tile.build(0, 2, 0) }
    let(:player) { Game::Player.new }
    let(:map) { mock(:map, :start_tile => start) }
    let(:passage) { Game::Object.instance('FeaturePassage', 'modules' => ['Passage'], 'id' => 'feature_key') }
    let(:key) { Game::Object.instance('FeatureKey', 'modules' => ['InventryItem'], 'id' => 'feature_key') }

    before do
      wall.add(passage)
      stop
    end

    it 'allows player movement through a door with a key' do
      player.add(key)
      player.load_map(map)
      player.move(Game::Map::SOUTH)
      player.tile.should == wall
      player.move(Game::Map::SOUTH)
      player.tile.should == stop
    end

    it 'passing the wall drops the key' do
      player.add(key)
      player.load_map(map)
      player.move(Game::Map::SOUTH)
      player.tile.should == wall
      player.should_not have_object(Game::Object::FeatureKey)
    end

    it 'passing the wall leaves the door open' do
      player.add(key)
      player.load_map(map)
      player.move(Game::Map::SOUTH)
      player.move(Game::Map::SOUTH)
      wall.should be_passible([])
    end
  end
end