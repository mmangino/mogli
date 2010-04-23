require 'rake'
require 'rubygems'
gem 'rspec'
require 'spec/rake/spectask'
 
desc 'Default: run unit tests.'
task :default => :spec
 
desc 'Test the  plugin.'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.libs << 'lib'
  t.verbose = true
end
