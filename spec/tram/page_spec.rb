require "spec_helper"

RSpec.describe Tram::Page do
  it "has a version number" do
    expect(Tram::Page::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
