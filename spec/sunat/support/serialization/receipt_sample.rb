Receipt.build do |i|
  i.correlative_number  = "10"
  
  i.ruc         = "20100113612"
  i.legal_name  = "K&G Laboratorios"
  
  i.make_accounting_customer_party ruc: "20382170114", name: "CECI FARMA IMPORT S.R.L."
  
  i.add_tax_total :igv, 874500, "PEN"
  
  i.add_line do |line|
    line.make_description "CAPTOPRIL 25mg"
    line.make_quantity 300, "CS"
    line.make_selling_price 17289000, "PEN"
    line.make_unitary_price 76800, "PEN"
    
    line.build_pricing_reference do |ref|
      ref.alternative_condition_prices << AlternativeConditionPrice.build do |acp|
        acp.price_type = "01"
        acp.build_price_amount do |amount|
          amount.value = 2000
          amount.currency = "PEN"
        end
      end
    end
    
    line.add_tax_total :igv, 26361, "PEN"
    line.add_tax_total :isc, 8745, "PEN"
  end
end