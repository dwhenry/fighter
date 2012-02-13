require 'spec_helper'

describe Game::Object::Weapon do
  subject { Game::Object.instance('WeaponTest', 'modules' => ['Weapon']) }
  let(:player) { Game::Player.new }

  describe '#equip' do
    it 'equips the item on the players weapon slot' do
      player.should_receive(:equip).with('weapon', subject)
      subject.equip
    end
  end
end