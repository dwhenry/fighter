require 'spec_helper'

describe Game::Object::Weapon do
  subject { Game::Object.instance('WeaponTest', 'modules' => ['Weapon'], 'attack' => 10) }
  let(:player) { Game::Player.new }

  describe '#equip' do
    it 'equips the item on the players weapon slot' do
      player.should_receive(:equip).with('weapon', subject)
      subject.equip
    end
  end

  describe '#use' do
    context 'tile in direction has that can be damaged' do
      let(:front_tile) { Game::Tile.build(0, 0, 0) }
      let(:tile)       { Game::Tile.build(0, 1, 0) }
      let(:enemy)      { Game::Object.instance('WeaponEnemyTest', 'modules' => ['Enemy'])}
      let(:engine) { mock(:engine, :map => map) }
      let(:map) { mock(:map, :name => 'name') }
      before do
        Game::Engine.stub(:instance => engine)
        player.add(subject)
        tile.add(player)
        front_tile.add(enemy)
      end

      it 'damages the object' do
        enemy.should_receive(:damage).with(10)
        subject.use
      end
    end
  end
end