require 'spec_helper'

describe Game::Object::Healer do
  subject { Game::Object.instance('HealerTest', 'modules' => ['Healer'], 'health' => 50) }
  let(:player) { mock(:player, :heal => 25) }
  let(:location) { Game::Location.build(0, 0, 0) }

  before do
    Game::Player.stub(:instance => player)
  end

  it 'heals the player of damage' do
    player.should_receive(:heal).with(50)
    subject.auto_process
  end

  it 'reduces the healling potention of the health box' do
    subject.auto_process
    subject.health.should == 25
  end

  it 'removes the object once all healing power has been used up' do
    location.add(subject)
    player.stub(:heal => 50)
    subject.auto_process
    location.should_not have_object(Game::Object::Healer)
  end
end
