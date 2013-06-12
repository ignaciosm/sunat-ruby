module SUNAT

  class AccountingSupplierParty
    include Model

    property :name,                   String
    property :account_id,             String
    property :additional_account_id,  String # code of document type... i don't know where to get the range of this values. TODO: Find the range of values and validates this field. I suspect that this is always the code for RUC.
    
    validates :account_id, existence: true, presence: true, sunat_document: true
  end

end
