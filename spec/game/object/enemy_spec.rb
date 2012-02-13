require 'spec_helper'

describe Game::Object::Enemy do
  subject { Game::Object.instance('TestEnemy', 'modules' => ['Enemy'])}

  describe '#passible?' do
    it 'is false' do
      subject.should_not be_passible
    end
  end

  describe '#status' do
    it 'is idle when left alone' do
      subject.status.should == Game::Object::Enemy::IDLE
    end
  end
end