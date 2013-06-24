module SUNAT
  #
  # The invoice is one of the primary or root models. It can be
  # used to generate an XML document suitable for presentation.
  # Represents a legal payment for SUNAT. Spanish: Factura
  #
  
  class Invoice < Document
    extend PaymentDocument
    
    DOCUMENT_TYPE_CODE = '01' # sunat code in catalog #1
    
    def voucher_serie
      "F001" # TODO: i really don't understand what should be content of the three characters after B.
    end
  end
end