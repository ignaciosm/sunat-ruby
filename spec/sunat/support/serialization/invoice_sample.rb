Invoice.new.tap do |invoice|
  invoice.correlative_number      = "10"
  
  # TODO: Research this for all the documents.
  # 
  # invoice.additional_monetary_totals << MonetaryTotal.new({
  #   id: '1001',
  #   payable_amount:   PaymentAmount.new(currency: 'PEN', value: 10000),
  #   reference_amunt:  PaymentAmount.new(currency: 'PEN', value: 10000),
  #   total_amount:     PaymentAmount.new(currency: 'PEN', value: 20000),
  # })
  # 
  # invoice.add_additional_property(id: '20000', value: 'COMPROBANTE DE PERCEPCION')
  
  invoice.ruc         = "20100113612"
  invoice.legal_name  = "K&G Laboratorios"
  
  invoice.make_accounting_customer_party(ruc: '20382170114', name: 'CECI FARMA IMPORT S.R.L.')
  
  invoice.add_tax_total :igv, 26231, "PEN"
  
  invoice.add_line do |line|
    line.make_quantity 300, :product
    line.make_selling_price 172890, "PEN"
    line.make_unitary_price 67800, "PEN"
    
    line.make_paid_price 2000, "PEN"
    line.add_tax_total :igv, 26361, "PEN"
    line.add_tax_total :isc, 8745, "PEN"
  end
end