module SUNAT
  
  class AccountingParty
    include Model
    
    property :account_id,             String
    property :additional_account_id,  String
    property :party,                  Party
    
    validates :account_id, existence: true, presence: true, ruc_document: true
    validates :additional_account_id, existence: true, document_type_code: true
    
    def build_party_with_name(name)
      self.party = Party.new.tap do |party|
        party.name = name
      end
    end
    
    def build_party_with_legal_name(*names)
      self.party = Party.new.tap do |party|
        names.each do |name|
          party.party_legal_entities << PartyLegalEntity.new.tap do |entity|
            entity.registration_name = name
          end
        end
      end
    end
    
    def build_xml(xml, tag_name)
      xml['cac'].send tag_name do
        # IMPORTANT: We don't know how to handle the case
        # when there is no dni. We are assuming that, because
        # sunat said that the fields are required, the the dni
        # field must be empty string when nil.
        xml['cbc'].CustomerAssignedAccountID  (account_id || '')
        xml['cbc'].AdditionalAccountID        additional_account_id
        
        party.build_xml xml
      end
    end
  end
end