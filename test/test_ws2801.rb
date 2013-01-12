require 'test/unit'
require 'ws2801'

class WS2801_Test < Test::Unit::TestCase

  def test_length_true
		WS2801.length(20)
    assert_equal 20, WS2801.length
  end

  def test_length_false
		WS2801.length(10)
    assert_not_equal 20, WS2801.length
  end

  def test_set_and_read_base_color
		WS2801.baseColor(110,20,0)
    assert_equal [110,20,0], WS2801.baseColor
  end

	def test_device
		assert_equal "/dev/spidev0.0", WS2801.device
	end

	def test_set_device
		WS2801.device("/dev/spidev0.1")
		assert_equal "/dev/spidev0.1", WS2801.device
	end

	def test_generate_strip
		WS2801.gen
	end

	def test_write
		WS2801.write
	end

	def test_reset
		WS2801.reset
	end

	def test_enable_first_and_last_in_blue
		WS2801.gen
		WS2801.put(14,0,0,245)
		WS2801.write
	end


end
