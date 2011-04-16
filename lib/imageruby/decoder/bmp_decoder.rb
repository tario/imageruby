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
require "imageruby/decoder"

class BmpDecoder < ImageRuby::Decoder
  def decode(data)

    # read bmp header
    header = data[0..13]
    dib_header = data[14..54]

    magic = header[0..1]

    # check magic
    unless magic == "BM"
      raise UnableToDecodeException
    end

    pixeldata_offset = header[10..13].unpack("L").first

    width = dib_header[4..7].unpack("L").first
    height = dib_header[8..11].unpack("L").first

    # create image object

    image = ImageRuby::Image.new(width,height)

    padding_size = ( 4 - (width * 3 % 4) ) % 4
    width_array_len = width*3 + padding_size

    # read pixel data
    height.times do |y|
      offset = pixeldata_offset+(height-y-1)*width_array_len
      index = (y*width)*3
      image.pixel_data[index..index+width*3] = data[offset..offset+width*3]
    end

    image

  end
end
