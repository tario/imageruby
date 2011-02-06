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
require "lib/encoder"
require "lib/bitmap"
require "lib/bitmap/rbbitmap"
require "lib/decoder/bmp_decoder"
require "lib/encoder/bmp_encoder"

module ImageRuby
  class Image
    include Bitmap.bitmap_representation

    def initialize(width_, height_)
      initialize_bitmap_representation(width_, height_)
    end

    # load a image from file
    def self.from_file(path)

      decoded = nil
      File.open(path,"rb") do |file|
        decoded = Decoder.decode(file.read)
      end

      decoded
    end

    def save(path, format)
      File.open(path, "wb") do |file|
        file.write encode(format)
      end
    end

    def encode(format)
      Encoder.encode(self,format)
    end

    def inspect()
      "#<ImageRuby::Image:#{object_id} @width=#{@width}, @height=#{@height}>"
    end
  end
end

