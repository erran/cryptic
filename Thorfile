# encoding: utf-8
$:.unshift File.expand_path("../lib", __FILE__)

require 'bundler'
require 'bundler/setup'
require 'thor/rake_compat'
require 'yard'

class Default < Thor
  include Thor::RakeCompat
  require 'bundler/gem_tasks'

  desc 'install', "Build and install cryptic-#{Cryptic::VERSION}.gem into system gems"
  def install
    Rake::Task['install'].execute
  end

  desc 'release', "Create tag v#{Cryptic::VERSION} and build and push cryptic-#{Cryptic::VERSION}.gem to Rubygems"
  def release
    Rake::Task['release'].execute
  end

  YARD::Rake::YardocTask.new
  desc 'yard', 'Generate YARD Documentation'
  def yard
    Rake::Task['yard'].execute
  end
end
