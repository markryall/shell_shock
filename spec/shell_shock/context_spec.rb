# frozen_string_literal: true

require_relative "../spec_helper"

class TestContext
  attr_reader :commands, :prompt, :out

  include ShellShock::Context

  def puts(message = nil)
    @out ||= []
    @out << message
  end
end

describe ShellShock::Context do
  before do
    allow(Readline).to receive(:readline)
    @context = TestContext.new
    allow(@context).to receive(:refresh_commands)
  end

  it "initialises commands if there are none in push" do
    @context.push

    expect(@context.commands.keys.sort).to eq(%w[? exit help quit])
  end

  it "sets up a default prompt in push" do
    @context.push

    expect(@context.prompt).to eq(" > ")
  end

  it "calls readline with configured prompt and store history" do
    @context.push

    expect(Readline).to have_received(:readline).with(" > ", true)
  end

  it "does not call readline when aborted" do
    @context.abort!
    @context.push

    expect(Readline).not_to have_received(:readline)
  end

  it "performs refresh_commands callback" do
    @context.push

    expect(@context).to have_received(:refresh_commands)
  end

  it "returns blank strings from head_tail for nil string" do
    head, tail = @context.head_tail nil

    expect(head).to eq("")
    expect(tail).to eq("")
  end

  it "returns blank strings from head_tail for blank string" do
    head, tail = @context.head_tail ""

    expect(head).to eq("")
    expect(tail).to eq("")
  end

  it "splits the head from the tail with a single word" do
    head, tail = @context.head_tail "a"

    expect(head).to eq("a")
    expect(tail).to eq("")
  end

  it "splits the head from the tail with a single word with trailing whitespace" do
    head, tail = @context.head_tail "a "

    expect(head).to eq("a")
    expect(tail).to eq("")
  end

  it "splits the head from the tail with multiple words" do
    head, tail = @context.head_tail "a b c "

    expect(head).to eq("a")
    expect(tail).to eq("b c")
  end
end
