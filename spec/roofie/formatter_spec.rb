require "spec_helper"

RSpec.describe Roofie::Formatter do
  it "spits out code" do
    code = "def hi; end"

    expect(Roofie.format(code)).to eq code
  end

  it "formats a bigger chunk of code" do
    code = <<~CODE
      require "passion_pit"

      PassionPit.find_the_sea_of_love(1..10.to_a)
    CODE

    expect(Roofie.format(code)).to eq code
  end

  it "formats an array" do
    code = <<~CODE
      x = [1, 2, 3, 4, 5, 6]
    CODE

    expect(Roofie.format(code)).to eq code
  end

  it "formats literal assignment" do
    code = <<~CODE
      x = 2
      y=3
    CODE

    expect(Roofie.format(code)).to eq "x = 2\ny = 3"
  end
end
