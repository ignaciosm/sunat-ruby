begin
  require 'pry' # useful to make `binding.pry` in a failing test to debug
rescue Exception => e
end


require 'bundler/setup'
require 'rspec'

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sunat'

module ValidationSpecHelpers
  def expect_valid(model, key, value)
    expect_validness(model, key, value, true)
  end
  
  def expect_invalid(model, key, value)
    expect_validness(model, key, value, false)
  end
  
  def expect_validness(model, key, value, validness)
    model.send("#{key.to_s}=", value)
    model.valid?
    model.errors.keys.send (validness ? :should_not : :should ), include(key)
  end
end

module SupportingSpecHelpers
  ROOT = [Dir.pwd, 'spec', 'sunat', 'support']
  
  def eval_support_script(route, extension = "rb")
    file = support_file("#{route}.#{extension}")
    code = file.read
    instance_eval(code)
  end
  
  def support_file(route)
    location = support_file_location(route)
    File.new location
  end
  
  def support_file_location(route)
    File.join(ROOT + [route])
  end
end

