require 'spec_helper'

describe Game::Location do
  describe '#class_methods' do
    before do
      Game::Location.clear
    end

    def board
      Game::Location.instance_variable_get('@board')
    end

    describe '#build' do
      it 'creates a new insatnce of the class and stores it for retreival' do
        Game::Location.build(0, 0, 0)
        board.should == {[0, 0] => Game::Location::Empty.new(0, 0, 0)}
      end
    end

    describe "#class_for" do
      it 'returns the appropriate class to for the location_type' do
        Game::Location.class_for(Game::Location::EMPTY_CELL).should == Game::Location::Empty
        Game::Location.class_for(Game::Location::WALL_0).should == Game::Location::Wall
        Game::Location.class_for(Game::Location::WALL_90).should == Game::Location::Wall
        Game::Location.class_for(Game::Location::WALL_CORNER_RIGHT).should == Game::Location::Wall
        Game::Location.class_for(Game::Location::WALL_CORNER_LEFT).should == Game::Location::Wall
      end

      it 'raises and error for an unknow location type' do
        expect { Game::Location.class_for('unknown') }.to raise_error
      end
    end

    describe "#clear" do
      it 'removes all items from the board' do
        Game::Location.build(0, 0, 0)
        Game::Location.clear
        board.should == {}
      end
    end

    describe "at" do
      it 'shorthand to get the value from the hash' do
        Game::Location.build(0, 0, 0)
        Game::Location.at(0, 0).should == board[[0, 0]]
      end
    end
  end
end

