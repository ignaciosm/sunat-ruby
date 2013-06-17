module SUNAT  
  class InvoiceLine
    include Model
    
    property :id,                     String
    property :invoiced_quantity,      Quantity
    property :line_extension_amount,  PaymentAmount # selling value
    property :price,                  PaymentAmount # price
    property :pricing_reference,      PriceReference
    property :tax_totals,             [TaxTotal]
    property :items,                  [Item]
    
    def initialize
      self.tax_totals = []
      self.items = []
    end
  end
end