require 'spec_helper'

describe Game::Tile::Movement do
  subject { Game::Tile.build(0, 1, 1) }

  describe '#at' do
    context 'retrieves the tile via the class at method' do
      it 'for up' do
        Game::Tile.should_receive(:at).with(0, 1)
        subject.at(Game::Map::NORTH)
      end

      it 'for down' do
        Game::Tile.should_receive(:at).with(2, 1)
        subject.at(Game::Map::SOUTH)
      end

      it 'for left' do
        Game::Tile.should_receive(:at).with(1, 0)
        subject.at(Game::Map::EAST)
      end

      it 'for right' do
        Game::Tile.should_receive(:at).with(1, 2)
        subject.at(Game::Map::WEST)
      end
    end

    it 'returns an edge element if the tile does not exist' do
      subject.at(:right).should be_a(Game::Tile::Edge)
    end

    context 'if the tile exists' do
      context 'if a tile effecting object exists' do
        it 'return the endpint instead' do
          end_point_tile = Game::Tile.build(0, 2, 2)
          up_tile = Game::Tile.build(0, 0, 1)
          up_tile.add(Game::Object.instance('Transport', "end_point" => [2, 2], 'modules' => ['TileModifier']))
          subject.at(Game::Map::NORTH).should == end_point_tile
        end
      end

      context 'if no tile effecting object exists' do
        it 'returns the tile' do
          up_tile = Game::Tile.build(0, 0, 1)
          subject.at(Game::Map::NORTH).should == up_tile
        end
      end
    end
  end

  describe '#direction_to' do
    let(:origin) { Game::Tile.build(0, 2, 2) }

    let(:north)  { Game::Tile.build(0, 0, 2) }
    let(:east)   { Game::Tile.build(0, 2, 4) }
    let(:south)  { Game::Tile.build(0, 4, 2) }
    let(:west)   { Game::Tile.build(0, 2, 0) }

    it 'when in an north direction' do
      origin.direction_to(north).should == Game::Map::NORTH
    end

    it 'when in an east direction' do
      origin.direction_to(east).should == Game::Map::EAST
    end

    it 'when in an south direction' do
      origin.direction_to(south).should == Game::Map::SOUTH
    end

    it 'when in an west direction' do
      origin.direction_to(west).should == Game::Map::WEST
    end
  end

  describe '#in_range?' do
    let(:origin) { Game::Tile.build(0, 0, 0) }

    let(:close_straight) { Game::Tile.build(0, 10, 0) }
    let(:far_straight)   { Game::Tile.build(0, 12, 0) }
    let(:close_angle)    { Game::Tile.build(0, 7, 7) }
    let(:far_angle)      { Game::Tile.build(0, 5, 9) }

    it 'when distance less is than max in a straight line' do
      origin.should be_in_range(close_straight)
    end

    it 'when distance greater is than max in a straight line' do
      origin.should_not be_in_range(far_straight)
    end

    it 'when distance less is than max on a diagonal line' do
      origin.should be_in_range(close_angle)
    end

    it 'when distance greater is than max on a diagonal line' do
      origin.should_not be_in_range(far_angle)
    end
  end
end