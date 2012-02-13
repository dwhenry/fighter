require 'spec_helper'

describe Game::Map do
  subject { Game::Map.new(File.join(File.dirname(__FILE__), '..', 'maps', 'test_map')) }

  describe '#load_map' do
    it 'creates a new instance of the map class' do
      Game::Map.should_receive(:new).with('map_file')
      Game::Map.load_map('map_file')
    end
  end

  it 'sets the map name' do
    subject.name.should == 'test_map'
  end

  describe '#data' do
    it 'returns the board elements mapped to Game::Tiles' do
      subject.data.should == [[Game::Tile::Empty.new(0, 0, 0), Game::Tile::Empty.new(1, 0, 1)],
                              [Game::Tile::Empty.new(2, 1, 0), Game::Tile::Empty.new(3, 1, 1)]]
    end
  end

  describe '#at' do
    it 'is an alternative way to access board data' do
      subject.at(1, 1).should == subject.data[1][1]
    end
  end

  describe '#[]' do
    it 'provides a shorthange to the data method' do
      subject[1][1].should == subject.data[1][1]
    end
  end

  describe '#start_tile' do
    it 'returns the tile at 0,0 by default' do
      subject.start_tile.should == subject.at(0, 0)
    end
  end

  describe '#setup_objects' do
    it 'does nothing if no objects specified' do
      subject.setup_objects
    end

    context 'when objects are specified' do
      subject { Game::Map.new(File.join(File.dirname(__FILE__), '..', 'maps', 'test_map_with_objects')) }

      it 'delegates object creation to the Object class' do
        instance = Game::Object.instance('TestObject', {})
        Game::Object.should_receive(:instance).with('TestObject', {}).and_return(instance)
        subject
      end

      it 'add an instance of the object to the map tile' do
        subject.at(1, 0).should have_object(Game::Object::TestObject)
      end
    end
  end
end