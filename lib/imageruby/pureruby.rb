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
require "imageruby/bitmap/bitmap"

module ImageRuby
  module PureRubyImageMethods

    # Save the image to a given file by path and format
    #
    # Example
    #
    #   image.save("output.bmp", :bmp)
    #
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

    # Returs the color of a pixel locate in the given x and y coordinates
    # or a rectangle section of the image if a range is specified
    #
    # Example
    #
    #   image[0,0] # return a Color object representing the color of the pixel at 0,0
    #   image[0..20,10..30] # return a image object with the cropped rectagle with x between 0 and 20 and y between 10 and 30
    #   image[0..20,20] # return a image object cropped rectagle with x between 0 and 20 and y equals 15
    #
    def [] (x,y)
      if x.instance_of? Fixnum and y.instance_of? Fixnum
        get_pixel(fixx(x),fixy(y))
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

    # Set the color of a pixel locate in the given x and y coordinates
    # or replace a rectangle section of the image with other image of equal dimensions
    # if a range is specified
    #
    # Example
    #
    #   image[0,0] = Color.red # set the color of pixel at 0,0 to Color.red
    #   image[0..20,10..30] = other_image # replace the rectagle with x between 0 and 20 and y between 10 and 30 with other_image
    #
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

    # Duplicates the image and draw into the duplicate with the given parameters (by calling draw!)
    def draw(x,y,image)
      obj = self.dup()
      obj.draw!(x,y,image)
      obj
    end

    # Draw a given image to the given x and y coordinates (matching left-upper corner of the drawn image)
    # when drawing, the method use the alpha channel of the origin image to properly implement
    # alpha drawing (transparency)
    #
    # Examples:
    #
    #   image.draw!(0,0,other_image)
    #
    def draw!(x,y,image)

        dest_pixel_data = self.pixel_data
        orig_pixel_data = image.pixel_data

        (0..image.height-1).each do |y_orig|
          y_dest = y_orig + y

          origpointer = y_orig*image.width*3
          destpointer = (y_dest*width+x)*3

          (0..image.width-1).each do |x_orig|
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


    # Walks each pixel on the image, block is mandantory to call this function and return
    # as yield block calls x,y and pixel color for each pixel of the image
    #
    # This function does not allow to modify any color information of the image (use map_pixel for that)
    #
    # Examples:
    #
    #   image.each_pixel do |x,y,color|
    #     print "pixel at (#{x},#{y}): #{color.inspect}\n"
    #   end
    #
    def each_pixel
      (0..@width-1).each do |x|
        (0..@height-1).each do |y|
          yield(x,y,get_pixel(x,y))
        end
      end
    end

    # Creates a new image of same dimensions in which each pixel is replaced with the value returned
    # by the block passed as parameter, the block receives the coordinates and color of each pixel
    #
    # Example
    #
    #   image_without_red = image.map_pixel{|x,y,color| color.r = 0; color } # remove color channel of all pixels
    def map_pixel
      Image.new(@width, @height) do |x,y|
        yield(x,y,get_pixel(x,y))
      end
    end

    # Replace each pixel of the image with the value returned
    # by the block passed as parameter, the block receives the coordinates and color of each pixel
    #
    # Example
    #
    #   image.map_pixel!{|x,y,color| color.r = 0; color } # remove color channel of all pixels
    def map_pixel!
      each_pixel do |x,y,color|
        set_pixel(x,y, yield(x,y,get_pixel(x,y)))
      end

      self
    end

    # Duplicate the image and then call color_replace! method with the given parameters
    def color_replace(color1, color2)

      newimage = self.dup
      newimage.color_replace!(color1,color2)
      newimage
    end

    # Replace the color given in the first argument by the color given in the second with alpha values
    #
    # Examples
    #
    #   image.color_replace!(Color.red, Color.black) # replace red with black
    #   image.color_replace!(Color.black, Color.coerce([0,0,0,128]) ) # replace black with %50 transparent black
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

    # Replace a color with %100 transparency, useful for mask drawing
    #
    # Example
    #
    #   masked = other_image.mask(Color.black)
    #   image.draw(0,0,masked) # draw the image without the black pixels
    def mask(color1 = nil)
      color1 = color1 || Color.from_rgb(255,255,255)
      color2 = color1.dup
      color2.a = 0

      color_replace(color1,color2)
    end

    # For sugar syntax, yield the image and then return self
    #
    # Example:
    #
    #   Image.from_file("input.bmp").on_chain{|img| img[0,0] = Color.red }.save("output.bmp")
    def on_chain
      yield(self); self
    end

    def inspect()
      "#<ImageRuby::Image:#{object_id} @width=#{@width}, @height=#{@height}>"
    end
  end

  register_image_mixin PureRubyImageMethods
end

