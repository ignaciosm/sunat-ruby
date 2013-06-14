module SUNAT
  
  class AccountingParty
    include Model
    
    property :account_id,             String
    property :additional_account_id,  String # TODO: Range in Catalog # 01
    property :party,                  Party
    
    validates :account_id, existence: true, presence: true, ruc_document: true
  end
end