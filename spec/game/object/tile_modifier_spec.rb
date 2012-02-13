require 'spec_helper'

describe Game::Object::TileModifier do
  subject { Game::Object.instance('TileModifierTest', 'modules' => ['TileModifier'] ,'end_point' => [1, 2]) }
  it 'takes a details hash' do
    subject
  end

  it 'has an end-point method' do
    subject.end_point.should == [1, 2]
  end

  it 'raises and error is the end-point is not set' do
    expect { TileModifierTest.new({}).end_point }.to raise_error
  end
end