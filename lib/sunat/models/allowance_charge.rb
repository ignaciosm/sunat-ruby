module SUNAT

  class AllowanceCharge
    include Model

    property :amount,           PaymentAmount
    property :charge_indicator, String
    
    validates :charge_indicator, inclusion: { in: ['true', 'false'] }
    
    def build_xml(xml)
      xml['cac'].AllowanceCharge do
        xml['cbc'].ChargeIndicator charge_indicator
        
        amount.build_xml xml, :Amount
      end
    end
    
  end

end
