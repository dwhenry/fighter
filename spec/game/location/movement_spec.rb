require 'spec_helper'

describe Game::Location::Movement do
  subject { Game::Location.build(0, 1, 1) }

  describe '#at' do
    context 'retrieves the tile via the class at method' do
      it 'for up' do
        Game::Location.should_receive(:at).with(0, 1)
        subject.at(:up)
      end

      it 'for down' do
        Game::Location.should_receive(:at).with(2, 1)
        subject.at(:down)
      end

      it 'for left' do
        Game::Location.should_receive(:at).with(1, 0)
        subject.at(:left)
      end

      it 'for right' do
        Game::Location.should_receive(:at).with(1, 2)
        subject.at(:right)
      end
    end

    it 'returns an edge element if the tile does not exist' do
      subject.at(:right).should be_a(Game::Location::Edge)
    end

    context 'if the tile exists' do
      context 'if a location effecting object exists' do
        it 'return the endpint instead' do
          end_point_tile = Game::Location.build(0, 2, 2)
          up_tile = Game::Location.build(0, 0, 1)
          up_tile.add(Game::Object.instance('Transport', "end_point" => [2, 2], 'modules' => ['LocationModifier']))
          subject.at(:up).should == end_point_tile
        end
      end

      context 'if no location effecting object exists' do
        it 'returns the tile' do
          up_tile = Game::Location.build(0, 0, 1)
          subject.at(:up).should == up_tile
        end
      end
    end
  end

end