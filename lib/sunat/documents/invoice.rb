module SUNAT
  #
  # The invoice is one of the primary or root models. It can be
  # used to generate an XML document suitable for presentation.
  # Represents a legal payment for SUNAT. Spanish: Factura
  #
  
  class Invoice < Document
    extend PaymentDocument
    
    DOCUMENT_TYPE_CODE = PaymentDocument::INVOICE
    
    # All the invoice structure is identical
    # to the paystub's one. All the structure
    # is inherited from PaymentDocument
    
    def xml_builder
      @xml_builder ||= XMLBuilders::InvoiceBuilder.new(self)
    end
  end
end