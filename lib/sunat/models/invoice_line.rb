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
    
    def build_xml(xml)
      xml['cac'].InvoiceLine do
        xml['cbc'].ID id
        
        invoiced_quantity.build_xml(xml, :InvoicedQuantity) if invoiced_quantity.present?
        line_extension_amount.build_xml(xml, :LineExtensionAmount) if line_extension_amount.present?
        
        pricing_reference.build_xml(xml) if pricing_reference.present?
        
        tax_totals.each do |total|
          total.build_xml xml
        end
        
        items.each do |item|
          item.build_xml xml
        end
        
        xml['cac'].Price do
          price.build_xml xml, :PriceAmount
        end
      end
    end
  end
end