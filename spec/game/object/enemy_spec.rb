require 'spec_helper'

describe Game::Object::Enemy do
  subject { Game::Object.instance('TestEnemy', 'modules' => ['Enemy'], 'attack' => 10)}
  let(:engine) { mock(:engine, :map => map) }
  let(:map) { mock(:map, :name => 'map_name') }
  before do
    Game::Engine.stub(:instance => engine)
  end

  describe '#passible?' do
    it 'is false' do
      subject.should_not be_passible
    end
  end

  describe '#status' do
    it 'is idle when left alone' do
      subject.status.should == Game::Object::IDLE
    end
  end

  describe '#initialization' do
    it 'added as an idle object' do
      Game::Object.should_receive(:add).with('map_name', Game::Object::IDLE, subject)
      subject
    end
  end

  describe '#active_turn' do
    let(:front_tile)   { Game::Tile.build(0, 0, 1) }
    let(:tile)         { Game::Tile.build(0, 1, 1) }
    let(:back_tile)    { Game::Tile.build(0, 2, 1) }
    let(:distant_tile) { Game::Tile.build(0, 3, 1) }
    let(:range_tile)   { Game::Tile.build(0, 11, 1) }
    let(:player) { Game::Player.new }
    before do
      tile.add(subject)
      front_tile
      back_tile
      distant_tile
      range_tile
      subject.instance_variable_set(:@status, Game::Object::ACTIVE)
    end

    it 'return raise an eror is status is not active' do
      subject.instance_variable_set(:@status, Game::Object::IDLE)
      expect { subject.active_turn }.to raise_error
    end

    context 'player directly in front' do
      before do
        tile.stub(:direction_to => Game::Map::NORTH, :in_range => true)
      end

      it 'attacks' do
        front_tile.add(player)
        player.should_receive(:damage).with(10)
        subject.active_turn
      end
    end

    context 'player out of active distance' do
      before do
        range_tile.add(player)
        tile.stub(:in_range? => false)
        tile.stub(:direction_to => Game::Map::NORTH, :range => true)
      end

      it 'sets the enemy unit to idle' do
        tile.should_receive(:direction_to).with(range_tile)
        Game::Object.should_receive(:remove).with('map_name', Game::Object::ACTIVE, subject)
        Game::Object.should_receive(:add).with('map_name', Game::Object::IDLE, subject)
        subject.active_turn
      end
    end

    context 'player not in front' do
      before do
        tile.stub(:direction_to => Game::Map::SOUTH, :in_range? => true)
      end

      it 'turn to face the player' do
        back_tile.add(player)
        tile.should_receive(:direction_to).with(back_tile)
        subject.active_turn
        subject.direction.should == Game::Map::SOUTH
      end

      it 'attack the player if in the new direction' do
        back_tile.add(player)
        player.should_receive(:damage).with(10)
        subject.active_turn
      end

      it 'move in the next direction if player is not directly there' do
        distant_tile.add(player)
        tile.should_receive(:remove).with(subject)
        back_tile.should_receive(:add).with(subject)
        subject.active_turn
      end
    end
  end
end