require 'spec_helper'

describe Game::Tile::Movement do
  def build_map(map_array)
    x = -1
    map_array.map do |row|
      y = -1
      x += 1
      row.map do |cell|
        y += 1
        Game::Tile.build(cell, x, y)
      end
    end
  end

  subject { Game::Tile.build(0, 1, 1) }
  before { Game::Tile.clear }

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
    let(:origin) { Game::Tile.build(0, 1, 1) }

    let(:north)  { Game::Tile.build(0, 0, 1) }
    let(:east)   { Game::Tile.build(0, 1, 0) }
    let(:south)  { Game::Tile.build(0, 2, 1) }
    let(:west)   { Game::Tile.build(0, 1, 2) }

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

  describe '#direction_to (more complex stuff)' do
    let(:wall) { Game::Tile::WALL_0 }

    it 'straight line' do
      tile_00 = Game::Tile.build(0, 0, 0)
      tile_10 = Game::Tile.build(0, 1, 0)
      tile_00.direction_to(tile_10).should == Game::Map::SOUTH
    end

    it 'around a corner' do
      tiles = build_map([
        [0, 0],
        [0, wall]
      ])

      tiles[1][0].direction_to(tiles[0][1]).should == Game::Map::NORTH
    end

    it 'a complex setup' do
      tiles = build_map([
        [0, 0, 0],
        [0, wall, wall],
        [0, 0, 0]
      ])

      tiles[2][1].direction_to(tiles[0][2]).should == Game::Map::EAST
    end

    context 'determines the best path' do
      let(:tiles) { build_map([
        [0, 0,    0,    0,    0],
        [0, wall, wall, wall, 0],
        [0, 0,    wall, 0,    0],
        [0, wall, wall, 0,    0],
        [0, 0,    0,    0,    0]
      ]) }

      it 'finds the way out of a blind alley' do
        tiles[2][1].direction_to(tiles[2][3]).should == Game::Map::EAST
      end

      it 'takes the shortest path' do
        tiles[2][0].direction_to(tiles[2][3]).should == Game::Map::SOUTH
      end

      it 'choose a path if multiple possible' do
        tiles[1][0].direction_to(tiles[2][3]).should == Game::Map::NORTH
      end

      it 'will change its mind when the other path become shorter' do
        tiles[0][0].direction_to(tiles[2][3]).should == Game::Map::WEST
      end
    end

    context 'naviagtion with moveable non-passible objects' do
      let(:tiles) { build_map([
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0]
      ]) }
      let(:enemy) { Game::Object.instance('PathEnemy', 'modules' => ['Enemy']) }
      let(:engine) { mock(:engine, :map => map) }
      let(:map) { mock(:map, :name => 'map_name') }
      before do
        Game::Engine.stub(:instance => engine)
      end

      it 'avoids non-passible objects' do
        tiles[1][1].add(enemy)
        tiles[1][0].direction_to(tiles[1][4]).should == Game::Map::NORTH
      end

      it 'does not crash when impassible objects' do
        tiles[1][1].add(enemy)
        tiles[0][1].add(enemy)
        tiles[1][0].direction_to(tiles[1][4]).should be_nil
      end
    end

  end

  describe '#elements_with' do
    let(:tiles) { build_map([
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0]
    ]) }
    let(:enemy) { Game::Object.instance('PathEnemy', 'modules' => ['Enemy']) }
    let(:engine) { mock(:engine, :map => map) }
    let(:map) { mock(:map, :name => 'map_name') }

    it 'finds all elements within one movement' do
      tiles[0][0].elements_within(1).should == [
        tiles[0][0], tiles[1][0], tiles[0][1]
      ]
    end

    it 'finds all elements within two movement' do
      tiles[0][0].elements_within(2).should == [
        tiles[0][0], tiles[1][0], tiles[0][1], tiles[1][1], tiles[0][2]
      ]
    end

    it 'includes elements that contain enemy' do
      Game::Engine.stub(:instance => engine)
      tiles[0][1].add(enemy)
      tiles[0][0].elements_within(1).should == [
        tiles[0][0], tiles[1][0], tiles[0][1]
      ]
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