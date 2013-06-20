module SUNAT

  class TaxTotal
    include Model

    property :tax_amount, PaymentAmount
    property :sub_totals, [TaxSubTotal]
    
    def initialize
      self.sub_totals = []
    end
    
    def build_xml(xml)
      xml['cac'].TaxTotal do
        tax_amount.build_xml xml, :TaxAmount
      
        sub_totals.each do |sub_total|
          sub_total.build_xml(xml)
        end
      end
    end
    
  end

end
