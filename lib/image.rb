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
require "lib/decoder"

module ImageRuby
  class Image

    class Color
      attr_accessor :r
      attr_accessor :g
      attr_accessor :b

      def initialize(r_,g_,b_)
        self.r = r_
        self.g = g_
        self.b = b_
      end

      def self.coerce(color)
        unless color.instance_of? Color
          raise ArgumentException
        end

        color
      end
    end

    attr_reader :width
    attr_reader :height

    def initialize(width_, height_)
      @array = Array.new(width_*height_)
      @width = width_
      @height = height_
    end

    # load a image from file
    def self.from_file(path)

      decoded = nil
      File.open(path,"rb") do |file|
        decoded = Decoder.decode(file.read)
      end

      decoded
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
end

