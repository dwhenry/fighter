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
          # this will fail if the name below is not unique as this results
          # in the object being pre-defined...
          instance = Game::Object.instance('UniqueTestObject', {'modules' => ['LocationModifier']})
          instance.class.ancestors.should include(Game::Object::LocationModifier)
        end
      end
    end
  end
end

describe Game::Object::LocationModifier do
  class LocationModifierTest
    include Game::Object::LocationModifier
  end
  subject { LocationModifierTest.new('end_point' => [1, 2]) }
  it 'takes a details hash' do
    subject
  end

  it 'has an end-point method' do
    subject.end_point.should == [1, 2]
  end

  it 'raises and error is the end-point is not set' do
    expect { LocationModifierTest.new({}).end_point }.to raise_error
  end
end