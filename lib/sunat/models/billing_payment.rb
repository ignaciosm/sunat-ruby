module SUNAT

  class BillingPayment
    include Model

    property :paid_amount,    PaymentAmount
    property :instruction_id, String
    
    def build_xml(xml)
      xml['sac'].BillingPayment do
        paid_amount.build_xml xml, :PaidAmount
      end
      xml['cbc'].InstructionID instruction_id
    end
  end

end