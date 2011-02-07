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
require "lib/color"

module ImageRuby

  module RubyBitmapModl

    attr_reader :width
    attr_reader :height

    def initialize_bitmap_representation(width_, height_)
      @width = width_
      @height = height_
      @array = "\000"*@width*@height*3
    end
    # return a Color object of a given x and y coord
    def [] (x,y)
      pointindex = (y*@width + x)*3
      Color.from_rgb(
        @array[pointindex],
        @array[pointindex+1],
        @array[pointindex+2]
        )

    end

    # set a color value for a image
    def []= (x,y,color)
      pointindex = (y*@width + x)*3
      @array[pointindex] = color.r
      @array[pointindex+1] = color.g
      @array[pointindex+2] = color.b
    end

    def set_point(x,y,r,g,b)
      pointindex = (y*@width + x)*3
      @array[pointindex] = r
      @array[pointindex+1] = g
      @array[pointindex+2] = b
    end

    def get_r(x,y)
      pointindex = (y*@width + x)*3
      @array[pointindex]
    end

    def get_g(x,y)
      pointindex = (y*@width + x)*3
      @array[pointindex+1]
    end

    def get_b(x,y)
      pointindex = (y*@width + x)*3
      @array[pointindex+2]
    end

    def get_bgr(x,y)
      pointindex = (y*@width + x)*3
      @array[pointindex..pointindex+2]
    end

  end

  class RubyBitmap < Bitmap
    def self.modl
      RubyBitmapModl
    end
  end
end

