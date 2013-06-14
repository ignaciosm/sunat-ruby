module SUNAT

  class TaxTotal
    include Model

    property :tax_amount, PaymentAmount
    property :sub_totals, [TaxSubTotal]
    
    def initialize
      self.sub_totals = []
    end
  end

end
