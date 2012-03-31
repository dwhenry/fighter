require 'spec_helper'

describe Game::Player::Equipment do
  subject { Game::Player.new }
  let(:weapon) { Game::Object.instance('EquipWeaponTest', 'modules' => ['Weapon'], 'on' => 'hand', 'size' => 1) }

  describe '#equip' do
    it 'add the item to the players list of equipment' do
      subject.equip(weapon)
      subject.equipment('hand').should == [weapon]
    end

    it 'can equip two weapons' do
      knife = Game::Object.instance('EquipWeaponTest', 'modules' => ['Weapon'], 'on' => 'hand', 'size' => 1)
      subject.equip(weapon)
      subject.equip(knife)
      subject.equipment('hand').should == [weapon, knife]
    end

    it 'can not equip the same weapon twice' do
      subject.equip(weapon)
      subject.equip(weapon)
      subject.equipment('hand').should == [weapon]
    end

    it 'does not allow equipment of an item over size limit for item posiiton' do
      sword = Game::Object.instance('EquipWeaponTest', 'modules' => ['Weapon'], 'on' => 'hand', 'size' => 10)
      subject.equip(weapon)
      subject.equip(sword).should be_false
      subject.equipment('hand').should == [weapon]
    end
  end

  describe '#unequip' do
    it 'removes the item from the user equipment' do
      subject.equip(weapon)
      subject.unequip(weapon)
      subject.equipment('hand').should == []
    end

    it 'returns fals if item is not equiped' do
      subject.unequip(weapon).should be_false
    end
  end

  describe '#equipment' do
    it 'return sthe hash of equipment if no vatiable passed in' do
      subject.equip(weapon)
      subject.equipment.should == {'hand' => [weapon]}
    end

    it 'returns the items at the location if location passed in' do
      subject.equip(weapon)
      subject.equipment('hand').should == [weapon]
    end

    it 'does not share the array across locations' do
      subject.equip(weapon)
      subject.equipment('foot').should == []
    end
  end
end