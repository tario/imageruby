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
require "rubygems"

def auto_require(prefix)
  # in Ruby 2.0 it appears Gem.source_index was removed. 
  # The same functionality can be found using Gem::Specification
  if defined?(Gem::Specification) && Gem::Specification.respond_to?(:each)
    Gem::Specification.each do |entry|
      if entry.name =~ prefix
        require entry.name
      end
    end
  else
    Gem.source_index.each do |entry|
      if entry[0] =~ prefix
        require entry[1].name
      end
    end
  end
end

