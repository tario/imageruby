require "rubygems"
require "imageruby"

include ImageRuby

colors = Image.from_file("colors.bmp")
gradients = Image.from_file("gradients.bmp")

without_mask = colors.draw(128,192,gradients)
without_mask.save("without_mask.bmp", :bmp)

with_mask = colors.draw(128,192,gradients.mask(Color.black))
with_mask.save("with_mask.bmp", :bmp)


