require "test_helper"

class RoofieTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Roofie::VERSION
  end

  def test_it_formats_code
    code = "def hi; end"
    assert_equal code, Roofie.format(code)
  end

  def test_it_formats_a_bigger_block_of_code
    code = <<~CODE
      require "passion_pit"

      PassionPit.find_the_sea_of_love(1..10.to_a)
    CODE

    assert_equal code, Roofie.format(code)
  end

  def test_it_formats_an_array
    code = <<~CODE
      x = [1, 2, 3, 4, 5, 6]
    CODE

    assert_equal code, Roofie.format(code)
  end
end
