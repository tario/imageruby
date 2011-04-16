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
require "imageruby/abstract/subclass_enum"

module ImageRuby
  class Encoder
    with_enumerable_subclasses

    class UnableToEncodeException < Exception

    end

    # encode a image with the given format writing the binary data to the output
    # output can be a string or a open file on binary mode
    # raises UnableToEncodeException if the specified format is unknown
    #
    # To save a image to a file on disk use the method Image#save
    #
    # Example
    #
    #   output = String.new
    #   Encoder.encode(image,:bmp,output)
    def self.encode(image,format,output)
      Encoder.each_subclass do |sc|
        encoder = sc.new

        begin
          return encoder.encode(image,format,output)
        rescue UnableToEncodeException

        end
      end

      raise UnableToEncodeException
    end
  end
end
