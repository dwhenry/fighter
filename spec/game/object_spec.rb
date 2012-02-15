require 'spec_helper'

describe Game::Object do
  describe '#class_methods' do
    describe '#instance' do
      before do
        Game::Object.instance('TestObject')
      end

      it 'creates a new class of the object name' do
        defined?(Game::Object::TestObject).should be_true
      end

      it 'returns an instance of the new class' do
        Game::Object.instance('TestObject').should be_a(Game::Object::TestObject)
      end

      context 'takes optional details hash' do
        it 'sets the base class if parent details' do
          instance = Game::Object.instance('UniqueTestObject', {'modules' => ['TileModifier']})
          instance.class.ancestors.should include(Game::Object::TileModifier)
        end
      end

      it 'stores the created instances for retrieval later' do
        passage = Game::Object.instance('StorageTestObject', {'modules' => ['Passage']})
        Game::Object.objects.should include(passage)
      end
    end

    describe '#add' do
      before { Game::Object.clear }

      it 'adds the object to the list of engine run objects' do
        Game::Object.add('test_map', Game::Object::IDLE, :object_here)

        Game::Object.engine_objects('test_map').should == {Game::Object::IDLE => [:object_here], Game::Object::ACTIVE => []}
      end
    end

    describe '#remove' do
      before { Game::Object.clear }

      it 'adds the object to the list of engine run objects' do
        Game::Object.add('test_map', Game::Object::IDLE, :object_here)
        Game::Object.remove('test_map', Game::Object::IDLE, :object_here)

        Game::Object.engine_objects('test_map').should == {Game::Object::IDLE => [], Game::Object::ACTIVE => []}
      end
    end
  end
end