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

# Add custom validators here to allow it to be used from any model,
# allowing every validator which extends from EachValidator
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
          message = (options[:message] || "should have at least one member.")
          record.errors.add attribute, message
        end
      end
    end
    
    # RUC Document Validator
    class RucDocumentValidator < ActiveModel::EachValidator
      RUC_CHARACTERS_SIZE = 11
      
      def validate_each(record, attribute, value)
        if !value.nil? and value.size != RUC_CHARACTERS_SIZE
          message = (options[:message] || "should have #{RUC_CHARACTERS_SIZE} characters")
          record.errors.add attribute, message
        end
      end
    end
    
    # Currency Code Validator
    class CurrencyCodeValidator < ActiveModel::EachValidator
      CURRENCY_CODE_LENGTH = 3
      CURRENCY_CODE_FORMAT = /[a-zA-Z]{3}|\d{3}/
      
      def validate_each(record, attribute, value)
        if !value.nil?
          valid = value.size == CURRENCY_CODE_LENGTH && !!(value =~ CURRENCY_CODE_FORMAT)
          if not valid
            message = (options[:message] || "should be a valid currency code according to ISO 4217.")
            record.errors.add attribute, message
          end
        end
      end
    end
    
  end
end