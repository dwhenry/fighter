require 'spec_helper'

describe Game::Object::Switcher do
  subject { Game::Object.instance('SwictherTest', 'modules' => ['Switcher'], 'toggle' => ['toggle_test'])}
  let(:door) { Game::Object.instance('SwictherDoorTest', 'modules' => ['Passage'], 'id' => 'toggle_test')}
  before do
    door
  end

  describe '#process' do
    it 'toggles the passible flag on toggle items' do
      subject.process
      door.should be_passible
    end
  end
end