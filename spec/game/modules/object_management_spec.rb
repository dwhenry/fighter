require 'spec_helper'

describe Game::Modules::ObjectManagement do
  let(:exit) { Game::Object.instance('LevelExit', 'modules' => ['Exit']) }
  subject { Game::Tile.build(0, 0, 0) }

  describe '#add' do
    it 'adds an object to the object list for the tile' do
      subject.add(exit)
      subject.should have_object(Game::Object::Exit)
    end
  end

  describe '#remove' do
    it 'removes an object from the object list for the tile' do
      subject.add(exit)
      subject.remove(exit)
      subject.should_not have_object(Game::Object::Exit)
    end
  end

  describe '#has_object?' do
    it 'returns true if tile has an instance of the object class' do
      subject.add(exit)
      subject.has_object?(Game::Object::Exit).should be_true
    end

    it 'returns true if an instance of a sub-class of the object class' do
      object = Game::Object.instance('SubClassOfExit', 'modules' => ['TileModifier'])
      subject.add(object)
      subject.has_object?(Game::Object::TileModifier).should be_true
    end

    it 'returns false if tile doesnt have an instance of the object class' do
      subject.has_object?(Game::Player).should be_false
    end
  end
end
