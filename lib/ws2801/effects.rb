#
# Controller for: RGB Pixel with WS2801 Chip (Effects)
# build for Diffused Digital RGB LED Pixels from Adafruits on Raspberry Pi
# but should work on any device and the same led chip
# (c) 2013 Roman Pramberger (roman@pramberger.ch)
#
# WS2801 user-space driver (effects)
#
#
module WS2801::Effects
	#
	# Stroboscope effect
	#
	# Example:
	#    >> WS2801E.stroboscope({ :timeout => 0.25, :times => 22, :r => 255 })
	#    >> WS2801E.stroboscope({ :b => 255, :g => 255 })
	#
	# Arguments (or nil):
	#    pixel: (Number-Array|Integer|:all)
	#    r: (Integer) 0-255 red
	#    g: (Integer) 0-255 green
	#    b: (Integer) 0-255 blue
	#    timeout: (Float)
	#    times: (Integer)
	#
	def self.stroboscope options = {}
		options[:pixel] = (0..(WS2801.length-1)).to_a if options[:pixel].nil? or options[:pixel] == :all
		options[:pixel] = [options[:pixel]] if options[:pixel].is_a? Numeric
		options[:r] = 0 if options[:r].nil?
		options[:g] = 0 if options[:g].nil?
		options[:b] = 0 if options[:b].nil?
		options[:times] = options[:times].to_i if !options[:times].is_a? Numeric
		options[:times] = 40 if options[:times] == 0
		options[:timeout] = options[:timeout].to_f
		options[:timeout] = 0.03 if options[:timeout] == 0.0

		breakme = 0
		options[:times].times do |c|
			if c % 2 == 0
				r = 0
				g = 0
				b = 0
			else
				r = options[:r]
				g = options[:g]
				b = options[:b]
			end
			WS2801.set({ 
				:pixel => options[:pixel], 
				:r => r,
				:g => g,
				:b => b
			})
			sleep( options[:timeout] )
		end
	end
	#
	# Pulse Effect
	#
    # Example:
    #    >> WS2801E.pulse({ :direction => :outer, :r => 255 })
    #    >> WS2801E.pulse({ :b => 255, :g => 255 })
    #
    # Arguments (or nil):
    #    pixel: (Number-Array|Integer|:all) [default: :all]
    #    r: (Integer) 0-255 red [default: 0]
    #    g: (Integer) 0-255 green [default: 0]
    #    b: (Integer) 0-255 blue [default: 0]
    #    direction: (Symbol) :start | :end | :inner | :outer [default: :start]
    #    timeout: (Float) [default: 0.1]
	#    keep: (Boolean) if pixels get blacked out [default: true]
    #
	def self.pulse options = {}
        options[:pixel] = (0..(WS2801.length-1)).to_a if options[:pixel].nil? or options[:pixel] == :all
        options[:pixel] = [options[:pixel]] if options[:pixel].is_a? Numeric
        options[:r] = 0 if options[:r].nil?
        options[:g] = 0 if options[:g].nil?
        options[:b] = 0 if options[:b].nil?
		options[:direction] = :start if options[:direction].nil?
		options[:timeout] = 0.1 if options[:timeout].to_f == 0.0
		options[:keep] = true if options[:keep].nil?		

		WS2801.generate if !options[:keep]
		if options[:direction] == :start
			WS2801.length.times do |i|
				WS2801.generate if !options[:keep]
				WS2801.set({ :r => options[:r], :g => options[:g], :b => options[:b], :pixel => i })
				sleep(options[:timeout])
			end
		elsif options[:direction] == :end
			WS2801.length.times do |i|
				WS2801.generate if !options[:keep]
				WS2801.set({ :r => options[:r], :g => options[:g], :b => options[:b], :pixel => WS2801.length-i })
				sleep(options[:timeout])
			end
		elsif options[:direction] == :inner
			first = WS2801.length/2.0
			if first % 1 != 0
				first = first.to_i + 1
			end
			WS2801.generate if !options[:keep]
            ((WS2801.length/2)+1).times do |i|
				WS2801.generate if !options[:keep]
				WS2801.set({ :pixel => [first-i, first+i], :r => options[:r], :g => options[:g], :b => options[:b] })
				sleep(options[:timeout])
			end
		elsif options[:direction] == :outer
 			WS2801.generate if !options[:keep]
			((WS2801.length/2)+1).times do |i|
				WS2801.generate if !options[:keep]
				WS2801.set({ :pixel => [0+i, WS2801.length-i], :r => options[:r], :g => options[:g], :b => options[:b] })
				sleep(options[:timeout])
			end
		end
	end	
end
