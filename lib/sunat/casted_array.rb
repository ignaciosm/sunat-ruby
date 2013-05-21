
module SUNAT

  # The SUNAT CastedArray is a special object wrapper that allows other Model's
  # or Objects to be stored in an array, but maintain casted ownership.
  #
  # Adding objects will automatically assign the Array's owner, as opposed
  # to the array itself.
  #
  class CastedArray
    extend Forwardable
    include Castable

    def_delegators :@_array, :to_a, :==, :eql?, :keys, :values,
      :each, :reject, :empty?,
      :clear, :pop, :shift, :delete, :delete_at,
      :encode_json, :as_json, :to_json

    def initialize(owner, property, values = [])
      @_array = []
      self.casted_by = owner
      self.casted_by_property = property
      if values.is_a?(Array)
        values.each{|value| self << value}
      end
    end

    def <<(obj)
      @_array << instantiate_and_cast(obj)
    end

    def push(obj)
      @_array.push(instantiate_and_cast(obj))
    end

    def unshift(obj)
      @_array.unshift(instantiate_and_cast(obj))
    end

    def []= index, obj
      @_array[index] = instantiate_and_cast(obj)
    end


    protected

    def instantiate_and_cast(obj)
      casted_by_property.cast(casted_by, obj)
    end


  end

end
