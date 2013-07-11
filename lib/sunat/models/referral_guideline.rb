module SUNAT
  class ReferralGuideline < DocumentReference
    DOCUMENT_CODE = '09' # referral guideline
  
    def initialize(*args)
      super(*args)
      self.document_type_code ||= DOCUMENT_CODE
    end
  end
end