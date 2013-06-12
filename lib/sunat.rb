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

# Models
require "sunat/models/payment_amount"
require "sunat/models/tax_sub_total"
require "sunat/models/tax_total"
require "sunat/models/billing_payment"
require "sunat/models/accounting_supplier_party"
require "sunat/models/allowance_charge"
require "sunat/models/summary_documents_line"

# Documents
require "sunat/documents/daily_receipt_summary.rb"

module SUNAT
  # Your code goes here...
end
