require 'spec_helper'

describe Game::Player::Movements do
  subject { Game::Player.new }
  let(:map) { mock(:map, :start_tile => tile) }
  let(:tile) { mock(:tile, :add => true, :remove => true) }
  before { Game::Tile.clear }

  describe '#load_map' do
    it 'sets the player start tile' do
      subject.load_map(map)
      subject.tile.should == tile
    end

    it 'add the player to tile objects' do
      tile.should_receive(:add).with(subject)
      subject.load_map(map)
    end
  end

  describe '#move' do
    let(:passible_tile) { mock(:passible_tile, :passible? => true, :add => true, :objects => []) }
    before do
      subject.load_map(map)
      tile.stub(:at => passible_tile)
    end

    it 'delegates the movement to the current tile' do
      tile.should_receive(:at).with(Game::Map::NORTH)
      subject.move(Game::Map::NORTH)
    end

    context 'the new tile is passible' do
      it 'moves the player' do
        subject.move(Game::Map::NORTH)
        subject.tile.should == passible_tile
      end

      it 'move the player object from the old tile to the new tile' do
        tile.should_receive(:remove).with(subject)
        passible_tile.should_receive(:add).with(subject)
        subject.move(Game::Map::NORTH)
      end

      it 'process and automatic actions' do
        subject.should_receive(:take_auto_action)
        subject.move(Game::Map::NORTH)
      end
    end

    context 'the new tile is not passible' do
      let(:unpassible_tile) { mock(:unpassible_tile, :passible? => false) }
      before do
        tile.stub(:at => unpassible_tile)
      end

      it 'does not move the player' do
        subject.stub(:print => true)
        subject.move(Game::Map::NORTH)
        subject.tile.should == tile
      end

      it 'plays a beep' do
        subject.should_receive(:print).with("\a")
        subject.move(Game::Map::NORTH)
      end
    end
  end
end