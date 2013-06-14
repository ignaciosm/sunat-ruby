require "bundler/gem_tasks"

require 'annotations/rake_task'

Annotations::RakeTask.new

# open the console

# default_console = :irb
default_console = :pry

# This code is little bit hacky but i wanted to have a full console fast
task :console do |t, command = default_console|
  if command == :pry
    require 'pry'
    $: << File.join(Dir.pwd, 'lib')
    require 'sunat'
    include SUNAT
    binding.pry
  else
    code = <<CODE
    $: << File.join(Dir.pwd, 'lib')
    require 'sunat'
    include SUNAT
CODE
  
    exec "pry -e \"#{code}\""
  end
end