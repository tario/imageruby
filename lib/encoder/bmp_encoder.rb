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

class BmpEncoder < Encoder

  def encode(image, format)
    unless format == :bmp
      raise UnableToEncodeException
    end

    data = String.new

    width = image.width
    height = image.height

    totalsize = 54 + width * height * 3

    data << build_bmp_header(totalsize)
    data << build_bmp_dib_header(image)

    data << "\000\000" # for allignment

    # write pixel data
    height.times do |y|
      width.times do |x|

        color = image[x,y]
        color_triplet = [color.b].pack("C") + [color.g].pack("C") + [color.r].pack("C")

        data << color_triplet
      end
    end

    data
  end

private
  def build_bmp_dib_header(image)
    data = String.new

    data << [40].pack("L") #size of header
    data << [image.width].pack("L")
    data << [image.height].pack("L")
    data << [1].pack("S") # nplanes
    data << [0x18].pack("L")  # depth
    data << [0].pack("S") # compress type
    data << [image.width*image.height*3].pack("S") # raw bitmap data size

    data << [0].pack("L") # hres
    data << [0].pack("L") # vres
    data << [0].pack("L") # ncolors
    data << [0].pack("L") # nimpcolors

    data
  end
  def build_bmp_header(totalsize)

    data = String.new

    data << "BM" # magic
    data << [totalsize].pack("L") # totalsize
    data << [0].pack("S") # creator1
    data << [0].pack("S") # creator2
    data << [54].pack("L") # offset

    data

  end
end
