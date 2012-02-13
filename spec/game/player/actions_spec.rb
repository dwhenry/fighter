require 'spec_helper'

describe Game::Player::Actions do
  subject { Game::Player.new }
  let(:map) { mock(:map, :start_tile => tile) }
  let(:tile) { Game::Tile.build(0, 0, 0) }

  before do
    subject.load_map(map)
  end

  describe '#take_action' do
    context 'pick up inventry items' do
      let(:stationary_object) { Game::Object.instance('TableTest') }
      let(:moveable_object) { Game::Object.instance('PlayerKeyTest', "modules" => ["InventryItem"]) }

      it "picks up any inventry items in the current tile and places them in the inventry" do
        subject.tile.add(moveable_object)
        subject.take_action
        subject.should have_object(Game::Object::PlayerKeyTest)
      end

      it "can not picks up non inventry item" do
        subject.load_map(map)
        subject.tile.add(stationary_object)
        subject.take_action
        subject.should_not have_object(Game::Object::TableTest)
      end

      it 'removes items from the map when they have been picked up' do
        subject.tile.add(moveable_object)
        subject.take_action
        subject.tile.should_not have_object(Game::Object::PlayerKeyTest)
      end
    end

    context 'run process on items' do
      let(:process_object) { Game::Object.instance('PlayerSwitcherTest', "modules" => ["Switcher"]) }

      it 'calls process on any objects that have a process method' do
        subject.tile.add(process_object)
        process_object.should_receive(:process)
        subject.take_action
      end
    end
  end

  describe '#auto_actions' do
    context 'run process on items' do
      let(:process_object) { Game::Object.instance('ExitTest', "modules" => ["Exit"]) }

      it 'calls process on any objects that have a process method' do
        subject.tile.add(process_object)
        process_object.should_receive(:auto_process)
        subject.take_auto_action
      end
    end
  end
end