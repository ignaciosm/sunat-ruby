module SUNAT
  
  class AccountingParty
    include Model
    
    property :account_id,             String
    property :additional_account_id,  String # TODO: Range in Catalog # 01
    property :party,                  Party
    
    validates :account_id, existence: true, presence: true, ruc_document: true
    
    def build_party_with_name(name)
      self.party = Party.new.tap do |party|
        party.party_name = PartyName.new.tap do |party_name|
          party_name.name = name
        end
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
  end
end