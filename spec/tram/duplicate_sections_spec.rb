# frozen_string_literal: true

require "spec_helper"

describe BlankPage do
  let(:klass) { Class.new(described_class) }

  before { klass.section :alfa, value: -> { :foo } }

  it "raises on section duplicate" do
    expect { klass.section :alfa, value: -> { :bar } }
      .to raise_error(StandardError, /Section alfa already exists/)
  end

  it "allows to overload section explicitly" do
    expect { klass.section :alfa, value: -> { :bar }, overload: true }
      .to change { klass.new.alfa }
      .from(:foo)
      .to(:bar)
  end
end
