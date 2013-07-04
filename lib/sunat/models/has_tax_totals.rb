module SUNAT
  module HasTaxTotals
    def add_tax_total(tax_name, amount, currency)      
      tax_total = TaxTotal.new
      tax_total.make_amount(amount, currency)
      tax_total.make_category(tax_name)
      tax_totals << tax_total
    end
  end
end