
module SUNAT

  #
  # The receipt summary is one of the primary or root models. It can be
  # used to generate an XML document suitable for presentation.
  #
  class DailyReceiptSummary
    include Model

    property :reference_date, Date

    property :accounting_supplier, AccountingSupplierParty

    property :lines, [SummaryDocumentsLine]

  end
end
