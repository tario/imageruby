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
module RubyImage
  module SubclassEnumerator
    # used internally. you should not call this method explicitly
    def inherited(b)
      @sub_classes = @sub_classes || Array.new
      @sub_classes << b
    end

    # enumerate the subclasses of the class
    #
    # Example:
    #
    #   print "available decoders:\n"
    #   Decoder.each_subclass do |decoder_class|
    #     p decoder_class
    #   end

    def each_subclass
      @sub_classes.to_a.each do |sc|
        yield(sc)
      end
    end
  end
end

class Object

  # Add mixin including each_subclass to the class (used on Encoder and Decoder class)
  #
  # Example
  #
  #   class Decoder
  #     with_enumerable_subclasses
  #     ...
  #   end
  def self.with_enumerable_subclasses
    class << self
      include RubyImage::SubclassEnumerator
    end
  end
end
