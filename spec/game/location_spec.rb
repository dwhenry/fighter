require 'spec_helper'

describe Game::Location do
  subject { Game::Location.new(0, 1, 1) }

  describe '#class_methods' do
    def board
      Game::Location.instance_variable_get('@board')
    end

    describe '#build' do
      it 'creates a new insatnce of the class and stores it for retreival' do
        Game::Location.build(0, 0, 0)
        board.should == {[0, 0] => Game::Location.new(0, 0, 0)}
      end
    end

    describe "#class_for" do
      it 'returns the appropriate class to for the location_type' do
        Game::Location.class_for(Game::Location::EMPTY_CELL).should == Game::Location
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

  describe '#at' do
    context 'retrieves the tile via the class at method' do
      it 'for up' do
        Game::Location.should_receive(:at).with(0, 1)
        subject.at(:up)
      end

      it 'for down' do
        Game::Location.should_receive(:at).with(2, 1)
        subject.at(:down)
      end

      it 'for left' do
        Game::Location.should_receive(:at).with(1, 0)
        subject.at(:left)
      end

      it 'for right' do
        Game::Location.should_receive(:at).with(1, 2)
        subject.at(:right)
      end
    end

    it 'returns an edge element if the tile does not exist' do
      subject.at(:right).should be_a(Game::Location::Edge)
    end

    context 'if the tile exists' do
      context 'if a location effecting object exists' do
        it 'return the endpint instead' do
          end_point_tile = Game::Location.build(0, 2, 2)
          up_tile = Game::Location.build(0, 0, 1)
          up_tile.add(Game::Object.instance('Transport', "end_point" => [2, 2], 'parent' => 'LocationModifier'))
          subject.at(:up).should == end_point_tile
        end
      end

      context 'if no location effecting object exists' do
        it 'returns the tile' do
          up_tile = Game::Location.build(0, 0, 1)
          subject.at(:up).should == up_tile
        end
      end
    end
  end

  describe '#passible?' do
    it 'true' do
      subject.should be_passible
    end
  end

  describe '#add' do
    it 'adds an object to the object list for the tile' do
      subject.add(Game::Object::Exit.new)
      subject.should have_object(Game::Object::Exit)
    end
  end

  describe '#remove' do
    it 'removes an object from the object list for the tile' do
      exit = Game::Object::Exit.new
      subject.add(exit)
      subject.remove(exit)
      subject.should_not have_object(Game::Object::Exit)
    end
  end

  describe '#has_object?' do
    it 'returns true if tile has an instance of the object class' do
      subject.add(Game::Object::Exit.new)
      subject.has_object?(Game::Object::Exit).should be_true
    end

    it 'returns true if an instance of a sub-class of the object class' do
      object = Game::Object.instance('SubClassOfExit', 'parent' => 'Exit')
      subject.add(object)
      subject.has_object?(Game::Object::Exit).should be_true
    end

    it 'returns false if tile doesnt have an instance of the object class' do
      subject.has_object?(Game::Player).should be_false
    end
  end
end