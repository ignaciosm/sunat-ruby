module SUNAT

  class AccountingParty
    include Model
    
    property :account_id,             String
    property :additional_account_id,  String
    property :party,                  Party
    
    validates :account_id, existence: true, presence: true, ruc_document: true
    validates :additional_account_id, existence: true, document_type_code: true

    # Build a new AccountingParty. Either provide a compelte hash containing
    # the regular structure, or provide a shortened version that will be
    # automatically converted from the following fields:
    #
    #  * name - name of the company
    #  * ruc  - Peruvian SUNAT ID
    #  * or dni - National ID number, for exports
    #
    def initialize(attrs = {})
      super(attributes_parser(attrs))
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

    protected

    def attributes_parser(attrs)
      ruc  = attrs.delete(:ruc)
      dni  = attrs.delete(:dni)
      name = attrs.delete(:name)
      if name
        if (dni || ruc)
          # Special case! Try set the properties accordingly.
          self.additional_account_id = dni ? Document::DNI_DOCUMENT_CODE : Document::RUC_DOCUMENT_CODE
          self.account_id = dni || ruc
        end

        if dni
          self.party = {name:name}
        else
          self.party = {
            party_legal_entities: [{
              registration_name: name
            }]
          }
        end
      end
      attrs
    end
  end
end
