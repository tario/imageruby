require "rubygems"
require "imageruby"

include ImageRuby

#  creates an image of 150x150 pixels filled with black
image = ImageRuby::Image.new(150,150, Color.black)

begin
# this only work if imageruby-bmp gem is installed
image.save("black.bmp", :bmp)
rescue
print "Error while trying to save, you must install imageruby-bmp gem"
end

