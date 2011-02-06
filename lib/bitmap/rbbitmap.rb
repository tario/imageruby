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
      @array = Array.new(@width*@height)
    end
    # return a Color object of a given x and y coord
    def [] (x,y)
      @array[y*@width + x]
    end

    # set a color value for a image
    def []= (x,y,color)
      @array[y*@width + x] = Color.coerce(color)
    end
  end

  class RubyBitmap < Bitmap
    def self.modl
      RubyBitmapModl
    end
  end
end

