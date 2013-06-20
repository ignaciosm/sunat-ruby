module SUNAT

  class TaxSubTotal
    include Model
    
    property :tax_amount,   PaymentAmount
    property :tax_category, TaxCategory
    
    def build_xml(xml)
      xml['cac'].TaxSubTotal do
        tax_amount.build_xml xml, :TaxAmount
        tax_category.build_xml xml
      end
    end
  end
end