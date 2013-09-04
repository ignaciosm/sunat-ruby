module SUNAT
  #
  # The invoice is one of the primary or root models. It can be
  # used to generate an XML document suitable for presentation.
  # Represents a legal payment for SUNAT. Spanish: Factura
  #
  
  class Invoice < Document
    extend PaymentDocument
    
    DOCUMENT_TYPE_CODE = '01' # sunat code in catalog #1
    
    ID_FORMAT = /F[A-Z\d]{3}-\d{1,8}/

  end
end
