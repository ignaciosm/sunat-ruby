module SUNAT
  #
  # The receipt summary is one of the primary or root models. It can be
  # used to generate an XML document suitable for presentation.
  #
  
  class DailyReceiptSummary < Document
    
    property :id,                   String
    property :reference_date,       Date
    property :accounting_supplier,  AccountingParty
    property :lines,                [SummaryDocumentsLine]
    property :notes,                [String]
    
    validates :accounting_supplier, existence: true
    validates :lines, not_empty: true
    
    def initialize
      super
      self.notes = []
      self.lines = []
    end
    
    def xml_builder
      @xml_builder ||= XMLBuilders::DailyReceiptSummaryBuilder.new(self)
    end
  end
end