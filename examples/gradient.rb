require "rubygems"
require "imageruby"

include ImageRuby

gradient_images = Array.new

gradient_images << Image.new(64,64) {|x,y| 
Color.from_rgb(x*4,y*4,0) 
}

gradient_images << Image.new(64,64) {|x,y| 
Color.from_rgb(0,x*4,y*4) 
}

gradient_images << Image.new(64,64) {|x,y| 
Color.from_rgb(y*4,0,x*4) 
}

(0..gradient_images.count-1).each do |i|
	gradient_images[i].save("gradient#{i}.bmp", :bmp)
end

all_gradient = Image.new(96*gradient_images.count, 96)

(0..gradient_images.count-1).each do |i|
	all_gradient.draw!(i*96+16, 16, gradient_images[i])
end

all_gradient.save("gradients.bmp", :bmp)