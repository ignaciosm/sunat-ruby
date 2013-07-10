module SUNAT  
  class InvoiceLine
    include Model
    include HasTaxTotals
    
    property :id,                     String
    property :invoiced_quantity,      Quantity
    property :line_extension_amount,  PaymentAmount # selling value
    property :price,                  PaymentAmount # price
    property :pricing_reference,      PriceReference
    property :tax_totals,             [TaxTotal]
    property :items,                  [Item]
    
    KNOWN_UNIT_CODES = {
      :product => "NIU",
      :service => "ZZ"
    }
    
    def initialize(*args)
      super(*args)
      self.tax_totals = []
      self.items = []
    end
    
    def make_description(description)
      self.items << Item.new.tap do |item|
        item.description = description
      end
    end
    
    def make_quantity(qty, unit_code)
      code = if unit_code.is_a?(Symbol) and real_code = KNOWN_UNIT_CODES[unit_code]
        real_code
      else
        unit_code
      end
      self.invoiced_quantity = Quantity.new(quantity: qty, unit_code: code)
    end
    
    def make_selling_price(amount, currency)
      self.line_extension_amount = PaymentAmount[amount, currency]
    end
    
    def make_unitary_price(amount, currency)
      self.price = PaymentAmount[amount, currency]
    end
    
    def make_paid_price(amount, currency)
      make_reference_price amount, currency, :add_paid_alternative_condition_price, :is_for_paid_price?
    end
    
    def make_referencial_unitary_price(amount, currency)
      make_reference_price amount, currency, :add_referencial_condition_price, :is_for_referencial_price?
    end
    
    def build_xml(xml)
      xml['cac'].InvoiceLine do
        xml['cbc'].ID id
        
        invoiced_quantity.build_xml(xml, :InvoicedQuantity) if invoiced_quantity.present?
        line_extension_amount.build_xml(xml, :LineExtensionAmount) if line_extension_amount.present?
        pricing_reference.build_xml(xml) if pricing_reference.present?
        
        tax_totals.each do |total|
          total.build_xml xml
        end
        
        items.each do |item|
          item.build_xml xml
        end
        
        xml['cac'].Price do
          price.build_xml xml, :PriceAmount
        end
      end
    end
    
    private
    
    def make_reference_price(amount, currency, add_condition_method, acp_checker_method)
      self.pricing_reference ||= PriceReference.new
      self.pricing_reference.tap do |ref|
        if ref.alternative_condition_prices.empty?
          ref.send(add_condition_method, amount, currency)
        else
          acp_to_edit = ref.alternative_condition_prices.find { |acp| acp.send(acp_checker_method) }
          if acp_to_edit
            acp_to_edit.price_amount = PaymentAmount[amount, currency]
          else
            ref.send(add_condition_method, amount, currency)
          end
        end
      end
    end
    
  end
end