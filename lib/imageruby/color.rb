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
module ImageRuby

    class Color

      class << self
        private :new
      end
      # Add a new named Color
      # Example:
      #
      #   Color.add_color_name("turquoise", "#30d5c8")
      #   Color.turqoise # returns recently added named color

      def self.add_color_name(color_name, value)
        color = Color.coerce(value)
        eval("@#{color_name} = color")
        eval("def self.#{color_name}; @#{color_name}; end")

        @color_hash ||= Hash.new
        @color_hash[color_name] = color
      end

      # return the list of named colors
      #
      #   Color.named_colors.each do |name, color|
      #     print "color '#{name}' = #{color.inspect}\n"
      #   end
      def self.named_colors
        @color_hash
      end

      # method for internal use
      def self.define_colors(hash)
        hash.each do |k,v|
          add_color_name(k,v)
        end
      end

      class ArgumentException < Exception

      end

      # red channel (between 0 and 255)
      attr_accessor :r
      # green channel (between 0 and 255)
      attr_accessor :g
      # blue channel (between 0 and 255)
      attr_accessor :b
      # alpha channel (between 0 and 255)
      attr_accessor :a

      alias :red :r
      alias :green :g
      alias :blue :b
      alias :alpha :a

      # Create a color from given red, green and blue values (between 0 and 255)
      #
      # Example:
      #   white = Color.from_rgb(255,255,255)

      def self.from_rgb(r_,g_,b_)
        from_rgba(r_,g_,b_,255)
      end

      # Create a color from given red, green, blue and alpha. values (between 0 and 255)
      #
      # Example:
      #   white = Color.from_rgba(255,255,255,128)

      def self.from_rgba(r_,g_,b_,a_)

        c = new
        c.r = r_
        c.g = g_
        c.b = b_
        c.a = a_

        c
      end

      # Compares two colors channel by channel (including alpha)
      def ==(c)
        return false unless c.instance_of? Color

        (c.r == @r) and (c.g == @g) and (c.b == @b) and (c.a == @a)
      end

      # Coerce color to convert Array with rgba values, String with hexadecimal web color code, or a Color
      # to a instance of color
      #
      # Examples:
      #   Color.coerce([255,0,0]) # returns #<ImageRuby::Color:0x7f48b0051040 @r=255, @a=255, @b=0, @g=0>
      #   Color.coerce("#FF0000") # returns #<ImageRuby::Color:0x7f48b0051040 @r=255, @a=255, @b=0, @g=0>
      #   Color.coerce("#F00" ) # returns #<ImageRuby::Color:0x7f48b0051040 @r=255, @a=255, @b=0, @g=0>
      #   Color.coerce(Color.red) # returns #<ImageRuby::Color:0x7f48b0051040 @r=255, @a=255, @b=0, @g=0>
      #

      def self.coerce(arg)
        if arg.instance_of? Color
          return arg
        elsif arg.instance_of? Array
          Color.from_rgba(arg[0],arg[1],arg[2],arg[3] || 255)
        elsif arg.instance_of? String
          if arg.size == 4
            Color.from_rgb((arg[1..1]*2).to_i(16),(arg[2..2]*2).to_i(16),(arg[3..3]*2).to_i(16) )
          elsif arg.size == 7
            Color.from_rgb((arg[1..2]).to_i(16),(arg[3..4]).to_i(16),(arg[5..6]).to_i(16) )
          else
            raise ArgumentException
          end
        else
          raise ArgumentException
        end
      end

      define_colors "red" => [255,0,0], "green" => [0,255,0] , "blue" => [0,0,255],
                  "white" => [255,255,255], "silver" => [0xc0, 0xc0, 0xc0], "gray" => [0x80,0x80,0x80],
                  "black" => [0,0,0], "maroon" => [0x80,0,0], "yellow" => [0xff,0xff,0],
                  "olive" => [0x80,0x80,0], "lime" => [0,0xff,0], "aqua" => [0, 0xff, 0xff],
                  "teal" => [0, 0x80, 0x80], "navy" => [0,0,0x80], "fuchsia" => [0xff,0x00,0xff],
                  "purple" => [0x80,0,0x80], "orange" => [0xff, 0xa5, 0]
    end

    def to_s
      b.chr + g.chr + r.chr
    end
end