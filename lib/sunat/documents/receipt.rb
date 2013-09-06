module SUNAT
  #
  # The receipt is one of the primary or root models. It can be
  # used to generate an XML document suitable for presentation.
  # Represents a legal payment for SUNAT. Spanish: Boleta
  #
  # A receipt is pretty much identical to an Invoice. The only
  # difference being that it uses a different ID format and
  # document type code.
  #
  class Receipt < Invoice
    
    DOCUMENT_TYPE_CODE = '03' # sunat code in catalog #1

    ID_FORMAT = /B[A-Z\d]{3}-\d{1,8}/
    
  end
end
