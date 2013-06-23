require "sunat/version"

# The dependencies are isolated into one file.
# The reason is because they can be loaded
# independently by zeus or another test utility.
require "sunat/dependencies"

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
require "sunat/models/tax_scheme"
require "sunat/models/tax_category"
require "sunat/models/tax_sub_total"
require "sunat/models/tax_total"
require "sunat/models/billing_payment"
require "sunat/models/country"
require "sunat/models/postal_address"
require "sunat/models/party_legal_entity"
require "sunat/models/physical_location"
require "sunat/models/party"
require "sunat/models/accounting_party"
require "sunat/models/allowance_charge"
require "sunat/models/summary_documents_line"
require "sunat/models/document_reference"
require "sunat/models/quantity"
require "sunat/models/alternative_condition_price"
require "sunat/models/price_reference"
require "sunat/models/item"
require "sunat/models/invoice_line"
require "sunat/models/additional_property"
require "sunat/models/monetary_total"
require "sunat/models/referral_guideline"

# Base Document
require "sunat/document"

# Documents
require "sunat/documents/daily_receipt_summary"
require "sunat/documents/payment_document"
require "sunat/documents/invoice"
require "sunat/documents/receipt"
require "sunat/signature"
require "sunat/signature_config"
require "sunat/documents/xml_document"
require "sunat/documents/xml_signer"

module SUNAT
  # Your code goes here...
end
