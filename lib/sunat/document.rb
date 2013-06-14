# Wrapper over model with some
# general properties to documents

module SUNAT
  class Document
    include Model
    
    property :issue_date, Date
    
    def initialize(today = Date.today)
      self.issue_date = today
    end
  end
end