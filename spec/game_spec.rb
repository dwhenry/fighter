require 'spec_helper'

describe Game do
  let(:player) { mock(:player) }
  let(:engine) { mock(:engine, :map => [:game, :state], :state => 'Game Over', :take_turn => true, :player => player)}
  let(:input) { mock(:input, :read => true) }
  let(:renderer) { mock(:renderer, :draw_map => true, :draw_message => true) }
  before do
    Game::Engine.stub(:new => engine)
    Game::Input.stub(:new => input)
    Render::Console.stub(:new => renderer)
    engine.stub(:ended?).and_return(false, true)
  end

  it 'creates a new game engine' do
    Game::Engine.should_receive :new
    subject
  end

  it 'create a new default renderer' do
    Render::Console.should_receive :new
    subject
  end

  describe '#play' do
    it 'draws the game state' do
      renderer.should_receive(:draw_map).with(engine)
      subject.play
    end

    it 'runs the game turn' do
      engine.should_receive(:take_turn)
      subject.play
    end

    it 'draws exit message when game ended' do
      renderer.should_receive(:draw_message).with(engine)
      subject.play
      engine.stub(:ended? => true)
    end
  end
end
