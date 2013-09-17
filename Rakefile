require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rubygems/package_task'
require 'rdoc/task'

spec = Gem::Specification.new do |s|
  s.name = 'imageruby'
  s.version = '0.2.5'
  s.author = 'Dario Seminara'
  s.email = 'robertodarioseminara@gmail.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'flexible and easy to use ruby gem for image processing'
  s.homepage = "http://github.com/tario/imageruby"
  s.has_rdoc = true
  s.license = 'GPL-3'
  s.extra_rdoc_files = [ 'README' ]
#  s.rdoc_options << '--main' << 'README'
  s.files = Dir.glob("{examples,lib,spec}/**/*") +
    [ 'LICENSE', 'AUTHORS', 'CHANGELOG', 'README', 'Rakefile' ]
end

desc 'Run tests'
task :default => [ :test ]

Rake::TestTask.new('test') do |t|
  t.libs << 'test'
  t.pattern = '{test}/**/test_*.rb'
  t.verbose = true
end

desc 'Generate RDoc'
Rake::RDocTask.new :rdoc do |rd|
  rd.rdoc_dir = 'doc'
  rd.rdoc_files.add 'lib', 'README'
  rd.main = 'README'
end

desc 'Build Gem'
Gem::PackageTask.new spec do |pkg|
  pkg.need_tar = true
end


desc 'Clean up'
task :clean => [ :clobber_rdoc, :clobber_package ]

desc 'Clean up'
task :clobber => [ :clean ]
