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
require "imageruby/filepersistor"

module ImageRuby
  class EncoderPersistor < FilePersistor
    def persist(image,path,format)

      encoded_string = String.new

      begin
        ImageRuby::Encoder.encode(image,format,encoded_string)

        File.open(path,"wb") do |file|
          file.write encoded_string
        end

      rescue ImageRuby::Encoder::UnableToEncodeException
        raise UnableToPersistException
      end
      nil
    end
  end
end