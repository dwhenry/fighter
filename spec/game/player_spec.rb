require 'spec_helper'

describe Game::Player do
  let(:map) { mock(:map, :start_location => location) }
  let(:location) { mock(:location, :add => true, :remove => true) }

  it 'sets an initial health' do
    subject.hp.should == 100
  end

  describe '#damage' do
    it 'reduces the players health' do
      subject.damage(25)
      subject.hp.should == 75
    end

    it 'has a minimum health of 0' do
      subject.damage(101)
      subject.hp.should == 0
    end

    it 'ends the game if the player hitpoints goes below 0' do
      Game::Engine.new
      subject.damage(101)
      Game::Engine.instance.should be_ended
    end
  end

  describe '#heal' do
    it 'increases the players health' do
      subject.damage(50)
      subject.heal(25)
      subject.hp.should == 75
    end

    it 'has a maximum health of 100' do
      subject.heal(101)
      subject.hp.should == 100
    end

    it 'returns the value of any used healing energy' do
      subject.damage(50)
      subject.heal(101).should == 50
    end
  end
end