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
  end
end