require 'spec_helper'

describe Game::Object::Trap do
  subject { Game::Object.instance('TrapTest', 'modules' => ['Trap'], 'damage' => 25) }
  let(:player) { Game::Player.new }

  it 'deals damage to the player' do
    player.should_receive(:damage).with(25)
    subject.auto_process
  end
end
