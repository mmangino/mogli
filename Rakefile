require 'rake'
require 'rubygems'

begin
  require 'spec'
  version = 1
rescue LoadError => e
  require 'rspec'
  version = 2
end

desc 'Default: run unit tests.'
task :default => :spec

# So it can we used for both versions of rspec
if version <= 1
  require 'spec/rake/spectask'
  desc 'Test the  plugin.'
  Spec::Rake::SpecTask.new(:spec) do |t|
    t.libs << 'lib'
    t.verbose = true
  end
else
  require 'rspec/core/rake_task'
  desc 'Test the  plugin.'
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.verbose = true
  end
end

