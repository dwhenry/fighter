require 'spec_helper'

describe Game::Tile::Passible do
  subject { Game::Tile.build(0, 0, 0) }

  describe '#passible?' do
    context 'when no objects' do
      it 'should be true' do
        subject.should be_passible([])
      end
    end

    context 'when objects' do
      let(:passible) { mock(:object, :tile= => true, :passible? => true) }
      let(:impassible) { mock(:object, :tile= => true, :passible? => false) }

      it 'true when all objects are passible' do
        subject.add(passible)
        subject.should be_passible([])
      end

      it 'false if any objects are impassible' do
        subject.add(impassible)
        subject.should_not be_passible([])
      end
    end
  end
end
