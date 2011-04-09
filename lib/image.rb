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
require "encoder"
require "decoder"
require "bitmap"
require "bitmap/rbbitmap"
require "baseimage"

module ImageRuby

  class Image < BaseImage

    ImageRuby.image_mixin.each do |modl|
      include modl
    end

    def initialize(width_, height_, color = nil)
      initialize_bitmap_representation(width_, height_, color)

      if block_given?
        (0..width_-1).each do |x_|
          (0..height_-1).each do |y_|
            set_pixel(x_,y_, yield(x_,y_) )
          end
        end
      end
    end

    def encode(format,output)
      Encoder.encode(self,format,output)
    end

    # load a image from file
    def self.from_file(path)

      decoded = nil
      File.open(path,"rb") do |file|
        decoded = Decoder.decode(file.read)
      end

      decoded
    end

  end
end

