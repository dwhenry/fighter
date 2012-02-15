require 'spec_helper'

describe Game::Object::Enemy do
  subject { Game::Object.instance('TestEnemy', 'modules' => ['Enemy'], 'attack' => 10)}
  let(:engine) { mock(:engine, :map => map) }
  let(:map) { mock(:map, :name => 'map_name') }
  before do
    Game::Engine.stub(:instance => engine)
  end

  describe '#status' do
    it 'is idle when left alone' do
      subject.status.should == Game::Object::IDLE
    end
  end

  describe '#activate' do
    it 'remove the object from the current queue' do
      Game::Object.should_receive(:remove).with('map_name', Game::Object::IDLE, subject)
      subject.activate
    end

    it 'sets the status to active' do
      subject.activate
      subject.status.should == Game::Object::ACTIVE
    end

    it 'add the object to the active queue' do
      subject
      Game::Object.should_receive(:add).with('map_name', Game::Object::ACTIVE, subject)
      subject.activate
    end
  end

  describe '#deactivate' do
    before { subject.activate }
    it 'remove the object from the current queue' do
      Game::Object.should_receive(:remove).with('map_name', Game::Object::ACTIVE, subject)
      subject.deactivate
    end

    it 'sets the status to idle' do
      subject.deactivate
      subject.status.should == Game::Object::IDLE
    end

    it 'add the object to the idle queue' do
      Game::Object.should_receive(:add).with('map_name', Game::Object::IDLE, subject)
      subject.deactivate
    end
  end

  describe '#expire' do
    let(:tile) { Game::Tile.build(0, 0, 0) }
    before do
      tile.add(subject)
    end

    it 'removes the object from the tile' do
      subject.tile.should_receive(:remove).with(subject)
      subject.expire
    end

    it 'remove the object from the current queue' do
      Game::Object.should_receive(:remove).with('map_name', Game::Object::IDLE, subject)
      subject.expire
    end

    it 'removes the object' do
      Game::Object.objects.should_receive(:delete).with(subject)
      subject.expire
    end
  end
end