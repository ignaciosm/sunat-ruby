module SUNAT
  #
  # The receipt is one of the primary or root models. It can be
  # used to generate an XML document suitable for presentation.
  # Represents a legal payment for SUNAT. Spanish: Boleta
  #
  
  class Receipt < Document
    extend PaymentDocument
    
    DOCUMENT_TYPE_CODE = PaymentDocument::PAYSTUB
    
    # All the receipt's structure is identical
    # to the invoice's one. All the structure
    # is inherited from PaymentDocument
    
    def xml_builder
      @xml_builder ||= XMLBuilders::ReceiptBuilder.new(self)
    end
  end
end
