require 'spec_helper'

describe MicropostsHelper do
  it "should have not change" do
    expect(wrap("test")).to match("test")
  end

  it "should have a space" do
    expect(wrap("a" * 31)).to match(/\&#8203/)
  end
end
