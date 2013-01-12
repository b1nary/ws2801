#
# Controller for: RGB Pixel with WS2801 Chip
# build for Diffused Digital RGB LED Pixels from Adafruits on Raspberry Pi
# (c) 2013 Roman Pramberger (roman.pramberger@gmail.com)

# WS2801 driver
module WS2801
	@@len = 25
	@@strip = []
	@@device = "/dev/spidev0.0"

	# Set/read length of strip
	#
	# Example:
	#	 >> WS2801.length(25)
	#	 >> WS2801.length
	#	 => 25
	#
	# Arguments (or nil):
	#	 count: (Integer)
	def self.length len = nil
		return @@len if len.nil?
		@@len = len
	end

	# Set/read device
	#
	# Example:
	#	 >> WS2801.device("/dev/spidev0.0")
	#	 >> WS2801.device
	#	 => "/dev/spidev0.0"
	#
	# Arguments (or nil):
	#	 device: (String)
	def self.device dev = nil
		return @@device if dev.nil?
		@@device = dev
	end

	# Generate empty strip array
	#
	# Example:
	#	 >> WS2801.gen
	def self.gen
		@@strip = Array.new(@@len*3+1)
	end

	# Return current Strip
	#
	# Example;
	#	 >> WS2801.strip
	def self.strip
		return @@strip
	end

	# Write stripinfo to device (if not empty)
	# this needs root rights
	#
	# Example:
	#	 >> WS2801.write
	def self.write
		return false if @@strip.nil?
	
		@@strip.each_with_index do |s,i|
			@@strip[i] = 0 if @@strip[i].nil?
		end

		File.open(@@device, 'w') do |file|
			file.write(@@strip.pack('C*'))
		end
	end

	# Put pixel X to
	#
	# Example:
	#	 >> WS2801.put 3, 120, 255, 120
	#
	# Arguments:
	#	 pixel (Integer)
	#	 red (Integer)
	#	 green (Integer)
	#	 blue (Integer)
	def self.put pixel, red, green, blue
		return false if @@strip.nil?
		@@strip[(pixel*3)] = red
		@@strip[(pixel*3)+1] = green
		@@strip[(pixel*3)+2] = blue
	end

	# Fill all pixel
	#
	# Example:
	#	 >> WS2801.fill 120, 255, 120
	#
	# Arguments:
	#	 red (Integer)
	#	 green (Integer)
	#	 blue (Integer)
	def self.fill red, green, blue
		self.gen if @@strip.length == 0
		((@@strip.size-1)/3).times do |i|
			@@strip[(i*3)]	 = red
			@@strip[(i*3)+1] = green
			@@strip[(i*3)+2] = blue
		end
	end

	# Reset pixel to black
	#
	# Example:
	#	 >> WS2801.reset
	def self.reset
		self.gen
		self.write
	end
end
