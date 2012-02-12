require 'spec_helper'

describe Game::Object::Exit do
  subject { Game::Object.instance('ExitTest', 'modules' => ['Exit'], 'next_map' => 'next')}

  describe '#process' do
    let(:second_map) { mock(:map) }
    before do
      Game::Map.stub(:load_map => second_map)
    end

    it 'attempts to load the next map' do
      Game::Map.should_receive(:load_map).with("maps/next")
      Game::Engine.instance.should_receive(:load_map).with(second_map)
      subject.auto_process
    end

    it 'sets the ended flag if the load fails' do
      last_map = Game::Object.instance('ExitTest', 'modules' => ['Exit'])
      Game::Engine.instance.should_receive(:end)
      last_map.auto_process
    end
  end

end