module SUNAT

  class TaxTotal
    include Model

    property :tax_amount, PaymentAmount
    property :sub_totals, [TaxSubTotal]
    
    def initialize(*args)
      super(*args)
      self.sub_totals ||= []
    end
    
    def make_amount(amount, currency)
      self.tax_amount = PaymentAmount[amount, currency]
      sub_total do |sub_total|
        sub_total.tax_amount = PaymentAmount[amount, currency]
      end
    end
    
    def make_category(tax_abbr)
      sub_total do |sub_total|
        sub_total.tax_category = TaxCategory.new.tap do |cat|
          cat.tax_scheme = TaxScheme.build_for(tax_abbr)
        end
      end
    end
    
    def build_xml(xml)
      xml['cac'].TaxTotal do
        tax_amount.build_xml xml, :TaxAmount
      
        sub_totals.each do |sub_total|
          sub_total.build_xml(xml)
        end
      end
    end
    
    private
    
    def sub_total(&block)
      sub_total = if sub_totals.any?
        sub_totals.first
      else
        TaxSubTotal.new
      end
      
      sub_totals << sub_total
      sub_total.tap(&block)
    end
    
  end

end
