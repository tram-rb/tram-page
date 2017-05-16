# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlankPage do
  it "has a version number" do
    expect(Tram::Page::VERSION).not_to be nil
  end

  it "returns empty hash" do
    expect(subject.to_h).to eq({})
  end
end
