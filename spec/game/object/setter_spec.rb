require 'spec_helper'

describe Game::Object::Setter do
  subject { Game::Object.instance('SetterTest', 'modules' => ['Setter'], 'close' => ['close_test'], 'open' => ['open_test'])}
  let(:close_test) { Game::Object.instance('SetterDoorTest', 'modules' => ['Passage'], 'id' => 'close_test', 'passible?' => true)}
  let(:open_test) { Game::Object.instance('SetterDoorTest', 'modules' => ['Passage'], 'id' => 'open_test')}

  before do
    close_test
    open_test
  end

  describe '#process' do
    it 'set the passible flag to false on close items' do
      subject.process
      close_test.should_not be_passible
    end

    it 'set the passible flag to true on open items' do
      subject.process
      open_test.should be_passible
    end
  end
end