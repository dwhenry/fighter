require 'spec_helper'

describe Game::Object::Passage do
  subject { build_passage(false) }

  def build_passage(passible)
    Game::Object.instance('PassageTest', 'modules' => ['Passage'], 'passible?' => passible)
  end

  describe '#passible?' do
    it 'is false by default' do
      build_passage(nil).should_not be_passible
    end

    it 'can be initialized to true' do
      build_passage(true).should be_passible
    end
  end

  describe '#open' do
    it 'sets the passiable flag to true' do
      subject.open
      subject.should be_passible
    end
  end

  describe '#close' do
    subject { build_passage(true) }

    it 'sets the passiable flag to true' do
      subject.close
      subject.should_not be_passible
    end
  end

  describe '#switch' do
    it 'changes the passible state' do
      subject.switch
      subject.should be_passible
      subject.switch
      subject.should_not be_passible
    end
  end
end
