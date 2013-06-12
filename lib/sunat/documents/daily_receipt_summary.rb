module SUNAT
  #
  # The receipt summary is one of the primary or root models. It can be
  # used to generate an XML document suitable for presentation.
  #
  class DailyReceiptSummary
    include Model

    property :reference_date, Date
    
    property :issue_date, Date

    property :accounting_supplier, AccountingSupplierParty
    
    property :lines, [SummaryDocumentsLine]
    
    property :notes, [String]
    
    validates :accounting_supplier, existence: true
    validates :lines, not_empty: true
    
    def initialize
      self.notes = []
      self.lines = []
      self.issue_date = Date.today
    end
  end
end