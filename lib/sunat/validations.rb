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
        if value.present? and value.any?
          message = (options[:message] || "should have at least one member.")
          record.errors.add attribute, message
        end
      end
    end
    
    # RUC Document Validator
    class RucDocumentValidator < ActiveModel::EachValidator
      RUC_CHARACTERS_SIZE = 11
      
      def validate_each(record, attribute, value)
        if value.present? and value.size != RUC_CHARACTERS_SIZE
          message = (options[:message] || "should have #{RUC_CHARACTERS_SIZE} characters")
          record.errors.add attribute, message
        end
      end
    end
    
    # Tax Document Type Code Validator (Document Type Valid for Taxes)
    class TaxDocumentTypeCodeValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        return if value.nil?
        if value.size != 2 || value =~ /[a-zA-Z]/
          record.errors[attribute] << (options[:message] || "is not a valid invoice type code")
        end
      end
    end
    
    # Tax Type Code Validator
    # follows http://www.unece.org/trade/untdid/d07a/tred/tred5153.htm
    class TaxTypeCodeValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        return if value.nil?
        unless value =~ /[A-Za-z]{3}/
          record.errors[attribute] << (options[:message] || "is not a valid tax type code")
        end
      end
    end
    
    # Document Type Code Validator (Documents)
    class DocumentTypeCodeValidator < ActiveModel::EachValidator
      VALID_CODES_HASH = {
        '0' => 'DOC.TRIB.NO.DOM.SIN.RUC',
        '1' => 'DOC. NACIONAL DE IDENTIDAD',
        '4' => 'CARNET DE EXTRANJERIA',
        '6' => 'REG. UNICO DE CONTRIBUYENTES',
        '7' => 'PASAPORTE',
        'A' => 'CED. DIPLOMATICA DE IDENTIDAD'
      }
      
      VALID_CODES = VALID_CODES_HASH.keys
      
      def validate_each(record, attribute, value)
        return if value.nil?
        if VALID_CODES.exclude?(value)
          record.errors[attribute] << (options[:message] || "is not a valid document type code")
        end
      end
    end
    
    # Currency Code Validator
    class CurrencyCodeValidator < ActiveModel::EachValidator
      CURRENCY_CODE_LENGTH = 3
      CURRENCY_CODE_FORMAT = /[a-zA-Z]{3}|\d{3}/
      
      def validate_each(record, attribute, value)
        if value.present?
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