require "bundler/gem_tasks"
require 'annotations/rake_task'

Annotations::RakeTask.new

def no_pry
  puts %Q{
    You need to install pry to run this console:
    
      >> gem install pry
    
    or add pry to your gemfile (gem "pry") and run `bundle install`
  }
end

# This code is little bit hacky but i wanted to have a full console fast
task :console do |t|
  begin
    require 'pry'
  rescue LoadError => e
    no_pry
  end
  
  # add this file to the load path
  $: << File.join(File.dirname(__FILE__), 'lib')
  # require sunat
  require 'sunat'
  # and include it here
  include SUNAT
  # starts pry in the current environment
  # [note: it's pretty awesome to use binding.pry to debug
  # non-rails projects :)]
  binding.pry
end