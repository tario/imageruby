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
      class ArgumentException < Exception

      end

      attr_accessor :r
      attr_accessor :g
      attr_accessor :b
      attr_accessor :a

      def self.from_rgb(r_,g_,b_)
        from_rgba(r_,g_,b_,255)
      end

      def self.from_rgba(r_,g_,b_,a_)

        c = Color.new
        c.r = r_
        c.g = g_
        c.b = b_
        c.a = a_

        c
      end

      def self.coerce(color)
        unless color.instance_of? Color
          raise ArgumentException
        end

        color
      end
    end
end