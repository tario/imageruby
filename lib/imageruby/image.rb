=begin

This file is part of the imageruby project, http://github.com/tario/imageruby

Copyright (c) 2011 Roberto Dario Seminara <robertodarioseminara@gmail.com>

imageruby is free software: you can redistribute it and/or modify
it under the terms of the gnu general public license as published by
the free software foundation, either version 3 of the license, or
(at your option) any later version.

imageruby is distributed in the hope that it will be useful,
but without any warranty; without even the implied warranty of
merchantability or fitness for a particular purpose.  see the
gnu general public license for more details.

you should have received a copy of the gnu general public license
along with imageruby.  if not, see <http://www.gnu.org/licenses/>.

=end
require "imageruby/encoder"
require "imageruby/decoder"
require "imageruby/bitmap/bitmap"
require "imageruby/bitmap/rbbitmap"
require "imageruby/fileloader"

module ImageRuby
  def self.register_image_mixin(modl)
    Image.class_eval{ include modl }
  end

  class Image
    include Bitmap.bitmap_representation

    # Create an image with the given width and height filled with the specified color (black if not specified)
    # Also, the method allow the construction of image pixel by pixel if a block is passed
    #
    # Examples:
    #
    #   image = Image.new(30,20) # creates an image of width 30, height 20 and filled with black
    #   image = Image.new(30,20,Color.orange) # creates an image of width 30, height 20 and filled with orange
    #   image = Image.new(30,20) {|x,y| Color.from_rgb(x*8,0,0) } # creates an image of width 30, height 20 and filled with a gradient
    def initialize(width_, height_, color = nil)
      super()
      initialize_bitmap_representation(width_, height_, color)

      if block_given?
        (0..width_-1).each do |x_|
          (0..height_-1).each do |y_|
            set_pixel(x_,y_, yield(x_,y_) )
          end
        end
      end
    end

    # encodes the image with the specific format writting the result to output
    # output can be a string or a open file on binary mode
    #
    # To save a image to a file on disk use the method Image#save
    def encode(format,output)
      Encoder.encode(self,format,output)
    end

    # load a image from file
    def self.from_file(path)
      FileLoader.load(path)
    end

  end
end

