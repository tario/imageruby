require "rubygems"
require "imageruby"

include ImageRuby

colors = Image.from_file("colors.bmp")
gradients = Image.from_file("gradients.bmp")

transparent_black = Color.black
transparent_black.a = 128


colors.draw(128,192,gradients.color_replace(Color.black, transparent_black)).save("sample1.bmp", :bmp)

half_transparent = gradients.map_pixel{ |x,y,c|
	c.a = 128 if x >144
	c
}
colors.draw(128,192,half_transparent).save("sample2.bmp", :bmp)


