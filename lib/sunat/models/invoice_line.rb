module SUNAT
  class Price
    include Model
    
    property :price_amount, PaymentAmount # unit value by item without taxes
  end
  
  class InvoiceLine
    include Model
    
    property :id,                     String
    property :invoiced_quantity,      Quantity
    property :line_extension_amount,  PaymentAmount # selling value
    property :price,                  Price
    property :pricing_reference,      PricingReference
    property :tax_totals,             [TaxTotal]
    property :items,                  [Item]
  end
end