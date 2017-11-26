# frozen_string_literal: true

require "spec_helper"

RSpec.describe InheritedPage do
  subject { described_class.new("test") }

  it "returns data hash with new and without skipped fields" do
    expect(subject.to_h).to eq(foo: "test", bam: "TEST")
  end

  it "doesn't change behaviour of the parent class" do
    expect(described_class.superclass.new("test").to_h).to \
      eq(bar: "test", foo: "test", baz: "test")
  end
end
