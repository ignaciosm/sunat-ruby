require "sunat/version"

require 'active_model'
require 'active_model/naming'
require 'active_model/serialization'
require 'active_model/validator'
require 'active_model/validations'

require 'active_support/core_ext'
require 'active_support/json'

# Base support modules
require "sunat/castable"
require "sunat/casted_array"
require "sunat/attributes"
require "sunat/properties"
require "sunat/property"
require "sunat/validations"
require "sunat/model"

# Documents
require "sunat/documents/daily_receipt_summary.rb"

module SUNAT
  # Your code goes here...
end
