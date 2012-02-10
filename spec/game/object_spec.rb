require 'spec_helper'

describe Game::Object do
  describe '#class_methods' do
    describe '#add' do
      context 'when objects are specified' do
        before do
          Game::Object.instance('TestObject')
        end

        it 'creates a new class of the object name' do
          defined?(Game::Object::TestObject).should be_true
        end

        it 'returns an insatcne of the new class' do
          Game::Object.instance('TestObject').should be_a(Game::Object::TestObject)
        end
      end
    end
  end
end