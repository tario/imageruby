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
require "lib/bitmap"

module ImageRuby
  module PureRubyImageMethods

    def save(path, format)
      File.open(path, "wb") do |file|
        str = String.new
        encode(format,str)
        file.write str
      end
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

        width = x.count
        (0..y.count-1).each do |y_|
          origpointer = y_*obj.width*3
          destpointer = ((y.first + y_)*self.width + x.first)*3

          self.pixel_data[destpointer..destpointer+obj.width*3-1] =
            obj.pixel_data[origpointer..origpointer+obj.width*3-1]

        end
      end
    end

    def draw(x,y,image,mask_color=nil)
      if mask_color
        draw_with_mask(x,y,image,mask_color)
      else
        draw_without_mask(x,y,image)
      end
    end

    def draw_without_mask(x,y,image)

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
                dest_pixel_data[destpointer..destpointer+2] = color
                destpointer = destpointer + 3
                origpointer = origpointer + 3
              end
          end
        end
    end

    def draw_with_mask(x,y,image,mask_color)

        dest_pixel_data = self.pixel_data
        orig_pixel_data = image.pixel_data

        mask_str_color = "___"

        mask_str_color[0] = mask_color.b
        mask_str_color[1] = mask_color.g
        mask_str_color[2] = mask_color.r

        (0..image.height-1).each do |y_orig|
          y_dest = y_orig + y

          origpointer = y_orig*image.width*3
          destpointer = (y_dest*width+x)*3

          (0..image.width-1).each do |x_orig|
            if block_given?
              next if yield(x_orig,y_orig, Color.from_rgb(255,255,255))
            end

            color = orig_pixel_data[origpointer..origpointer+2]

            if color != mask_str_color then
              alpha = image.alpha_data[y_orig*image.width+x_orig]
              if alpha < 255
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
                dest_pixel_data[destpointer..destpointer+2] = color
                destpointer = destpointer + 3
                origpointer = origpointer + 3
              end
            else
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

      strcolor1 = str_color color1
      strcolor2 = str_color color2

      a = color2.a

      (0..width*height).each do |i|
        if pixel_data[i*3..i*3+2] == strcolor1 then
          pixel_data[i*3..i*3+2] = strcolor2
          alpha_data[i] = a
        end
      end
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

