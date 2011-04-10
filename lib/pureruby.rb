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
require "bitmap"

module ImageRuby
  module PureRubyImageMethods

    def save(path, format)
      File.open(path, "wb") do |file|
        str = String.new
        encode(format,str)
        file.write str
      end
    end

private
    def fixx(x)
      x - (x / width) * width
    end
    def fixy(y)
      y - (y / height) * height
    end
public

    def [] (x,y)
      if x.instance_of? Fixnum and y.instance_of? Fixnum
        get_pixel(x,y)
      else
        x = (fixx(x)..fixx(x)) if x.instance_of? Fixnum
        y = (fixy(y)..fixy(y)) if y.instance_of? Fixnum

        if x.instance_of? Range
          x = (fixx(x.first)..fixx(x.last))
        end

        if y.instance_of? Range
          y = (fixy(y.first)..fixy(y.last))
        end

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

        width = x.count
        (0..y.count-1).each do |y_|
          origpointer = y_*obj.width*3
          destpointer = ((y.first + y_)*self.width + x.first)*3

          self.pixel_data[destpointer..destpointer+obj.width*3-1] =
            obj.pixel_data[origpointer..origpointer+obj.width*3-1]

        end
      end
    end

    def draw(x,y,image)

        dest_pixel_data = self.pixel_data
        orig_pixel_data = image.pixel_data

        (0..image.height-1).each do |y_orig|
          y_dest = y_orig + y

          origpointer = y_orig*image.width*3
          destpointer = (y_dest*width+x)*3

          (0..image.width-1).each do |x_orig|
            if block_given?
              next if yield(x_orig,y_orig, Color.from_rgb(255,255,255))
            end

            color = orig_pixel_data[origpointer..origpointer+2]

              alpha = image.alpha_data[y_orig*image.width+x_orig]

                if alpha < 255
                  if alpha > 0
                    dest_pixel_data[destpointer] =
                      ( orig_pixel_data[origpointer]*(alpha+1) + dest_pixel_data[destpointer]*(255-alpha) ) / 256
                      origpointer = origpointer + 1
                      destpointer = destpointer + 1

                    dest_pixel_data[destpointer] =
                      ( orig_pixel_data[origpointer]*(alpha+1) + dest_pixel_data[destpointer]*(255-alpha) ) / 256
                      origpointer = origpointer + 1
                      destpointer = destpointer + 1

                    dest_pixel_data[destpointer] =
                      ( orig_pixel_data[origpointer]*(alpha+1) + dest_pixel_data[destpointer]*(255-alpha) ) / 256
                      origpointer = origpointer + 1
                      destpointer = destpointer + 1

                  else
                    destpointer = destpointer + 3
                    origpointer = origpointer + 3
                  end
                else
                  dest_pixel_data[destpointer..destpointer+2] = color
                  destpointer = destpointer + 3
                  origpointer = origpointer + 3
                end
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

    def color_replace(color1, color2)

      newimage = self.dup
      newimage.color_replace!(color1,color2)
      newimage
    end

    def color_replace!( color1, color2)
      strcolor1 = color1.to_s
      strcolor2 = color2.to_s

      a = color2.a

      (0..width*height).each do |i|
        if pixel_data[i*3..i*3+2] == strcolor1 then
          pixel_data[i*3..i*3+2] = strcolor2
          alpha_data[i] = a
        end
      end
    end

    def mask(color1 = nil)
      color1 = color1 || Color.from_rgb(255,255,255)
      color2 = color1.dup
      color2.a = 0

      color_replace(color1,color2)
    end

    def on_chain
      yield(self); self
    end

    def inspect()
      "#<ImageRuby::Image:#{object_id} @width=#{@width}, @height=#{@height}>"
    end
  end

  register_image_mixin PureRubyImageMethods
end

