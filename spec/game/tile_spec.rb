require 'spec_helper'

describe Game::Tile do
  describe '#class_methods' do
    before do
      Game::Tile.clear
    end

    def board
      Game::Tile.instance_variable_get('@board')
    end

    describe '#build' do
      it 'creates a new insatnce of the class and stores it for retreival' do
        Game::Tile.build(0, 0, 0)
        board.should == {[0, 0] => Game::Tile::Empty.new(0, 0, 0)}
      end
    end

    describe "#class_for" do
      it 'returns the appropriate class to for the tile_type' do
        Game::Tile.class_for(Game::Tile::EMPTY_CELL).should == Game::Tile::Empty
        Game::Tile.class_for(Game::Tile::WALL_0).should == Game::Tile::Wall
        Game::Tile.class_for(Game::Tile::WALL_90).should == Game::Tile::Wall
        Game::Tile.class_for(Game::Tile::WALL_CORNER_RIGHT).should == Game::Tile::Wall
        Game::Tile.class_for(Game::Tile::WALL_CORNER_LEFT).should == Game::Tile::Wall
      end

      it 'raises and error for an unknow tile type' do
        expect { Game::Tile.class_for('unknown') }.to raise_error
      end
    end

    describe "#clear" do
      it 'removes all items from the board' do
        Game::Tile.build(0, 0, 0)
        Game::Tile.clear
        board.should == {}
      end
    end

    describe "at" do
      it 'shorthand to get the value from the hash' do
        Game::Tile.build(0, 0, 0)
        Game::Tile.at(0, 0).should == board[[0, 0]]
      end
    end
  end
end

