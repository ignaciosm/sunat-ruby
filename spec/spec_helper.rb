
require 'bundler/setup'
require 'rspec'

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sunat'

module SpecHelpers
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