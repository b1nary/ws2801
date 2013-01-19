#
# Testing the user-space driver (ws2801)
# with wonderful colors <3
#
require_relative '../lib/ws2801.rb'

WS2801.generate                # generate empty strip (Would happen from alone if you just start setting colors)

WS2801.length 25               # default
WS2801.device "/dev/spidev0.0" # default
WS2801.autowrite true          # default

WS2801.set :pixel => :all, :r => 255 # set all to red

# Flash from inner to out
10.times do |x|
	c = { :r => rand(255), :g => rand(255), :b => rand(100) }
	((WS2801.length/2).to_i+1).times do |i|
		WS2801.set :pixel => (((WS2801.length/2).to_i-i)..((WS2801.length/2).to_i+i)).to_a, :r => c[:r], :g => c[:g], :b => c[:b]
		sleep(0.05)
	end
	c = nil
end

# Flash from outer to in
10.times do |x|
	c = { :r => rand(255), :g => rand(255), :b => rand(100) }
	((WS2801.length/2).to_i+1).times do |i|
		WS2801.set :pixel => ((WS2801.length-i)..WS2801.length).to_a + (0..i).to_a, :r => c[:r], :g => c[:g], :b => c[:b]
		sleep(0.03)
	end
	c = nil
end

# Blink red
20.times do |i|
	if i % 2 == 0
		WS2801.set :r => 255	
	else
		WS2801.off
	end
	sleep(0.05)
end

# Blink green
40.times do |i|
	if i % 2 == 0
		WS2801.set :g => 255	
	else
		WS2801.off
	end
	sleep(0.02)
end

# Strobo
40.times do |i|
	if i % 2 == 0
		WS2801.set :g => 255, :r => 255, :g => 255
	else
		WS2801.off
	end
	sleep(0.03)
end

# fade to red
WS2801.fade :r => 255

# fade to green
WS2801.fade :g => 255, :timeout => 0.001

# fade to blue
WS2801.fade :b => 255, :timeout => 0.01

# fade to off
WS2801.fade :timeout => 0.02
