require 'spec_helper'

describe Game::Engine do
  let(:first_map) { mock(:first_map, :next => "next")}
  let(:location) { mock(:location, :has_object? => true)}
  let(:player) { mock(:player, :load_map => true, :location => location) }
  before do
    Game::Map.stub(:load_map => first_map)
    Game::Player.stub(:new => player)
  end

  it 'loads the default map file' do
    Game::Map.should_receive(:load_map).with('maps/level1')
    subject
  end

  describe '#take_turn' do
    let(:second_map) { mock(:second_map)}

    it 'should check if on the exit tile' do
      location.should_receive(:has_object?).with(Game::Object::Exit)
      subject.take_turn
    end

    context 'when player is on the Exit tile' do
      it 'attempts to load the next map' do
        subject
        Game::Map.should_receive(:load_map).with("maps/next").and_return(second_map)
        player.should_receive(:load_map).with(second_map)
        subject.take_turn
      end

      it 'sets the ended flag if the load fails' do
        subject
        Game::Map.should_receive(:load_map).and_raise(NoMethodError)
        subject.take_turn
        subject.should be_ended
      end
    end

    it 'does nothing if player is not on the exit tile' do
      subject.take_turn
    end
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
end