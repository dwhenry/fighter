require 'spec_helper'

describe Game::Player do
  let(:map) { mock(:map, :start_location => location) }
  let(:location) { mock(:location, :add => true, :remove => true) }

  describe '#load_map' do
    it 'sets the player start location' do
      subject.load_map(map)
      subject.location.should == location
    end

    it 'add the player to location objects' do
      location.should_receive(:add).with(subject)
      subject.load_map(map)
    end
  end

  describe '#move' do
    let(:passible_location) { mock(:passible_location, :passible? => true, :add => true) }
    before do
      subject.load_map(map)
      location.stub(:at => passible_location)
    end

    it 'delegates the movement to the current location' do
      location.should_receive(:at).with(:up)
      subject.move(:up)
    end

    context 'the new location is passible' do
      it 'moves the player' do
        subject.move(:up)
        subject.location.should == passible_location
      end

      it 'move the player object from the old location to the new location' do
        location.should_receive(:remove).with(subject)
        passible_location.should_receive(:add).with(subject)
        subject.move(:up)
      end
    end

    context 'the new location is not passible' do
      let(:unpassible_location) { mock(:unpassible_location, :passible? => false) }
      before do
        location.stub(:at => unpassible_location)
      end

      it 'does not move the player' do
        subject.stub(:print => true)
        subject.move(:up)
        subject.location.should == location
      end

      it 'plays a beep' do
        subject.should_receive(:print).with("\a")
        subject.move(:up)
      end
    end
  end
end