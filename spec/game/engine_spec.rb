require 'spec_helper'

describe Game::Engine do
  let(:first_map) { mock(:first_map, :next => "next")}
  let(:tile) { mock(:tile, :has_object? => true)}
  let(:player) { mock(:player, :load_map => true, :tile => tile) }
  before do
    Game::Map.stub(:load_map => first_map)
    Game::Player.stub(:new => player)
  end

  it 'loads the default map file' do
    Game::Map.should_receive(:load_map).with('maps/level1')
    subject
  end

  describe '#take_turn' do
  end

  describe '#state' do
    it 'returns runnding' do
      subject.state.should == 'Running'
    end
  end

  describe '#ended?' do
    it 'false by default' do
      subject.should_not be_ended
    end

    it 'true when the ended state is set' do
      subject.instance_variable_set('@ended', true)
      subject.should be_ended
    end
  end

  describe '#end' do
    it 'sets the ended flag' do
      subject.end('')
      subject.should be_ended
    end
  end
end