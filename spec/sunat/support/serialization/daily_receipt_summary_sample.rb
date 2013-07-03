DailyReceiptSummary.new.tap do |s|
  s.reference_date  = Date.strptime("2012-06-23", "%Y-%m-%d")
  s.notes           = ["nota 1", "nota 2", "nota3"]
  
  s.ruc = "20100113612"
  s.legal_name = "K&G Laboratorios"
  
  s.lines << SummaryDocumentsLine.new.tap do |line|
    line.serial_id = "BA98"
    line.start_id = "456"
    line.end_id = "764"
    
    line.add_billing_payment 9823200, "PEN"
    line.add_billing_payment 0, "PEN"
    line.add_billing_payment 23200, "PEN"
    
    line.add_allowance_charge 500, "PEN"
    line.add_allowance_discount 0, "PEN"
    
    line.add_tax_total do |total|
      total.make_amount 0, "PEN"
      total.make_category id: "2000", name: "ISC", tax_type_code: "EXC"
    end
    
    line.add_tax_total do |total|
      total.make_amount 1768100, "PEN"
      total.make_category id: "1000", name: "IGV", tax_type_code: "VAT"
    end
    
    # line.total_amount = PaymentAmount[11735000, "PEN"]
  end
end