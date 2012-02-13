require 'spec_helper'

describe Render::Console::DrawMessage do
  let(:string_io) { StringIO.new }
  let(:engine) { mock(:engine, :message => "This is the system message.") }
  subject { Render::Console.new(string_io) }

  before do
    subject.stub(:system => true)
  end

  def output
    subject.draw_message(engine)

    string_io.rewind
    string_io.read.split("\n\r")
  end

  it 'writes the engine message to the screen' do
    output.should include("  +       This is the system message.       +")
  end

  it 'writes the game over title' do
    output.should include('  +               Game Over                +')
  end
end
