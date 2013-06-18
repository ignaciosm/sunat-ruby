# Wrapper over model with some
# general properties to documents

module SUNAT
  class Document
    include Model
    
    DEFAULT_CUSTOMIZATION_ID = "1.0"
    
    property :issue_date, Date
    property :customization_id, String
    
    def initialize
      super
      self.issue_date = Date.today
    end
    
    def customization_id
      self['customization_id'] ||= DEFAULT_CUSTOMIZATION_ID
    end
  end
end