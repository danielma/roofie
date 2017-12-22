require "spec_helper"

RSpec.describe Roofie::Formatter do
  it "spits out code" do
    code = "def hi; end"

    expect(Roofie.format(code)).to eq code
  end

  it "formats a bigger chunk of code" do
    code = %(
      require "passion_pit"

      PassionPit.find_the_sea_of_love(1..10.to_a)
    )

    expect(Roofie.format(code).strip).to eq code.strip
  end

  it "formats an array" do
    code = "
      [1, 2, 3, 4, 5, 6]

        [1, 2,3]
    "

    expect(Roofie.format(code).strip).to eq code.strip
  end

  it "formats literal assignment" do
    code = "
      x = 2
      y=3
    "

    expect(Roofie.format(code)).to eq "x = 2\ny = 3\n"
  end

  it "formats this file" do
    code = File.read(__FILE__)

    expect(Roofie.format(code)).to eq code
  end
end
