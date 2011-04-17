require "rubygems"
require "imageruby"

include ImageRuby

print "list of named colors:\n"
print "--------------------------\n"

colors = Array.new

Color.named_colors.each do |name, color|
	print "#{name}: #{color.inspect}\n"
	colors << color
end

image = Image.new( colors.count * 32, 512)

x = 0
colors.each do |color|
image[x..x+31, 0..511] = Image.new(32,512,color)
x = x + 32
end

image.save("colors.bmp", :bmp)


