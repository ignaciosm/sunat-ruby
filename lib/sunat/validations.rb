module SUNAT

  # Use ActiveModel Validations so that complex models can be
  # validated before generating a declaration document.
  module Validations
    extend ActiveSupport::Concern
    include ActiveModel::Validations

    # Determine if the model is valid.
    #
    # SUNAT Models are not designed for perisistance, so the context
    # is always assumed to be "create".
    def valid?(*args)
      super(:create)
    end

    module ClassMethods
      # Here we should add support for validating casted models
    end

  end
end

# Add custom validators here to allow it to be used from any model
# allowing everty validator which extends from EachValidator
# to be used with the validates method.
# 
# validates :field, existence: true #=> ExistenceValidator
# 
module ActiveModel
  module Validations
    
    # Tests if not nil. The default PresenceValidator only tests string emptyness.
    class ExistenceValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        record.errors.add attribute, (options[:message] || "doesn't exist.") if value.nil?
      end
    end
    
    # Tests if not empty. The LengthValidator only works with Strings
    class NotEmptyValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)        
        if !value.nil? and value.any?
          messae = (options[:message] || "should have at least one member.")
          record.errors.add attribute, messae
        end
      end
    end
    
    class SunatDocumentValidator < ActiveModel::EachValidator
      SUNAT_CHARACTERS_SIZE = 11
      
      def validate_each(record, attribute, value)
        if !value.nil? and value.size != SUNAT_CHARACTERS_SIZE
          message = (options[:message] || "should have #{SUNAT_CHARACTERS_SIZE} characters")
          record.errors.add attribute, message
        end
      end
    end
    
  end
end