# frozen_string_literal: true

require "spec_helper"

describe BlankPage do
  it "raises on section duplicate" do
    described_class.section :alfa
    described_class.section :beta
    expect { described_class.section :alfa }.to raise_error(
      /Section alfa already exists/
    )
  end
end
