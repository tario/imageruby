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
require "color"

module ImageRuby

  module RubyBitmapModl

    attr_reader :width
    attr_reader :height

    def initialize_bitmap_representation(width_, height_, color = nil)

      color ||= Color.from_rgb(0,0,0)

      @width = width_
      @height = height_
      @array = color.to_s*@width*@height
    end
    # return a Color object of a given x and y coord
    def get_pixel(x,y)
      index = (y*@width + x)
      pointindex = index*3
      Color.from_rgba(
        @array[pointindex+2],
        @array[pointindex+1],
        @array[pointindex],
        @alpha ? @alpha[index] : 255
        )

    end

    def initialize_dup(orig)
      @alpha = orig.alpha_data.dup
      @array = orig.pixel_data.dup
      self
    end

    def dup
      ret = super
      ret.initialize_dup(self)
    end

    # set a color value for a image
    def set_pixel(x,y,color)

      index = (y*@width + x)
      pointindex = index*3
      @array[pointindex+2] = color.r
      @array[pointindex+1] = color.g
      @array[pointindex] = color.b

      if color.a != 255 then
        @alpha = "\xff"*(@height * @width) unless @alpha
        @alpha[index] = color.a
      end

      self
    end

    def pixel_data
      @array
    end

    def alpha_data=(al)
      @alpha = al
    end

    def alpha_data
      @alpha = "\xff"*(@height * @width) unless @alpha
      @alpha
    end

  end

  class RubyBitmap < Bitmap
    def self.modl
      RubyBitmapModl
    end
  end
end

