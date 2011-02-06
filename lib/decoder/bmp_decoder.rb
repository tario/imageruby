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

class BmpDecoder < Decoder
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

    image = Image.new(width,height)

    # read pixel data
    width.times do |x|
      height.times do |y|
        offset = pixeldata_offset+(y*width)+x
        color_triplet = data[offset..offset+2]
        image[x,y] = Color.from_rgb(
            color_triplet[0],
            color_triplet[1],
            color_triplet[2]
            )
      end
    end

    image

  end

  def encode(image, format)
    unless format == :bmp
      raise UnableToEncodeException
    end
  end
end
