# frozen_string_literal: true

require "spec_helper"

RSpec.describe ExamplePage do
  subject { described_class.new("test") }

  it "returns data hash" do
    expect(subject.to_h).to eq(bar: "test", foo: "test", baz: "test")
  end

  it ":except" do
    expect(subject.to_h(except: :bar)).to eq(foo: "test", baz: "test")
  end

  it ":only" do
    expect(subject.to_h(only: :foo)).to eq(foo: "test")
  end

  it ":if and :unless" do
    expect(described_class.new(nil).to_h).to eq(foo: nil)
  end

  it "defines method for block section" do
    expect(subject.baz).to eq("test")
  end

  it "computes only required fields" do
    allow(subject).to receive(:foo_alias)
    subject.to_h(only: :bar)
    expect(subject).not_to have_received(:foo_alias)
  end
end
