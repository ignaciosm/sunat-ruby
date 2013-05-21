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
