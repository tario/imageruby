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

      if block_given?
        (0..width_-1).each do |x_|
          (0..height_-1).each do |y_|
            set_pixel(x_,y_, yield(x_,y_) )
          end
        end
      end
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
        str = String.new
        encode(format,str)
        file.write str
      end
    end

    def encode(format,output)
      Encoder.encode(self,format,output)
    end

    def [] (x,y)
      if x.instance_of? Fixnum and y.instance_of? Fixnum
        get_pixel(x,y)
      else
        x = (x..x) if x.instance_of? Fixnum
        y = (y..y) if y.instance_of? Fixnum

        newimg = Image.new(x.last + 1 - x.first, y.last + 1 - y.first)

        width = x.count
        (0..y.count).each do |y_|

          destpointer = y_*width*3
          origpointer = ((y.first + y_)*self.width + x.first)*3

          newimg.pixel_data[destpointer..destpointer+width*3] =
            self.pixel_data[origpointer..origpointer+width*3]
        end

        newimg
      end
    end

    def []= (x,y,obj)
      if x.instance_of? Fixnum and y.instance_of? Fixnum
        set_pixel(x,y,obj)
      else
        x = (x..x) if x.instance_of? Fixnum
        y = (y..y) if y.instance_of? Fixnum

        x.each do |x_|
          y.each do |y_|
            set_pixel(x_,y_, obj.get_pixel(x_ - x.first,y_ - y.first) )
          end
        end
      end
    end

    def draw(x,y,image,mask_color=nil)
        image.each_pixel do |x_,y_,color|
          if block_given?
            next if yield(x_,y_,color)
          end
          if color != mask_color then

            defcolor = color
            if color.a < 255 then
              origcolor = get_pixel(x+x_,y+y_)
              defcolor = Color.from_rgb(
                ( color.r*(color.a+1) + origcolor.r*(255-color.a) ) / 256,
                ( color.g*(color.a+1) + origcolor.g*(255-color.a) ) / 256,
                ( color.b*(color.a+1) + origcolor.b*(255-color.a) ) / 256
                )
            end

            set_pixel(x_+x,y_+y,defcolor)
          end
        end
    end

    def each_pixel
      (0..@width-1).each do |x|
        (0..@height-1).each do |y|
          yield(x,y,get_pixel(x,y))
        end
      end
    end

    def map_pixel
      Image.new(@width, @height) do |x,y|
        yield(x,y,get_pixel(x,y))
      end
    end

    def map_pixel!
      each_pixel do |x,y,color|
        set_pixel(x,y, yield(x,y,get_pixel(x,y)))
      end

      self
    end

    def on_chain
      yield(self); self
    end

    def inspect()
      "#<ImageRuby::Image:#{object_id} @width=#{@width}, @height=#{@height}>"
    end
  end
end

