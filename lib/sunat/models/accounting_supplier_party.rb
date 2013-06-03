module SUNAT

  class AccountingSupplierParty
    include Model

    property :name, String

    property :account_id, String
    property :additional_account_id, String

  end

end
