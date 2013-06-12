module SUNAT

  class TaxSubTotal
    include Model
    
    property :tax_amount,     PaymentAmount
    property :tax_category,   String # id of the tax in sunat's catalog
    property :tax_name,       String # name of the tax
    property :tax_type_code,  String # code of the tax type (search later for the range of valid values)
  end
end