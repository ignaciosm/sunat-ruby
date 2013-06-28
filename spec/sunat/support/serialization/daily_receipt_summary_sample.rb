DailyReceiptSummary.new.tap do |s|
  s.reference_date  = Date.strptime("2012-06-23", "%Y-%m-%d")
  s.notes           = ["nota 1", "nota 2", "nota3"]
  
  s.build_accounting_supplier_party do |supplier|
    supplier.account_id = "20100113612"
    supplier.additional_account_id = "6"
    supplier.build_party_with_legal_name "K&G Laboratorios"
  end
  
  s.lines << SummaryDocumentsLine.new.tap do |line|
    line.document_type_code = '03'
    
    line.line_id = "1"
    line.serial_id = "BA98"
    line.start_id = "456"
    line.end_id = "764"
    
    line.total_amount = PaymentAmount[117350, "PEN"]
        
    line.billing_payments << BillingPayment.new.tap do |billing|
      billing.build_paid_amount do |payment|
        payment.currency = "PEN"
        payment.value = 98232
      end
      billing.instruction_id = "01"
    end
    
    line.billing_payments << BillingPayment.new.tap do |billing|
      billing.build_paid_amount do |payment|
        payment.currency = "PEN"
        payment.value = 0
      end
      billing.instruction_id = "02"
    end
    
    line.billing_payments << BillingPayment.new.tap do |billing|
      billing.build_paid_amount do |payment|
        payment.currency = "PEN"
        payment.value = 232
      end
      billing.instruction_id = "03"
    end
    
    line.allowance_charges << AllowanceCharge.new.tap do |charge|
      charge.charge_indicator = "true"
      charge.build_amount do |amount|
        amount.currency = "PEN"
        amount.value = 5
      end
    end
    
    line.tax_totals << TaxTotal.new.tap do |total|
      total.build_tax_amount do |amount|
        amount.currency = "PEN"
        amount.value = 0
      end
      
      total.sub_totals << TaxSubTotal.new.tap do |subtotal|
        subtotal.build_tax_amount do |amount|
          amount.currency = "PEN"
          amount.value = 0
        end
        subtotal.build_tax_category do |cat|
          cat.build_tax_scheme do |scheme|
            scheme.id = "2000"
            scheme.name = "ISC"
            scheme.tax_type_code = "EXC"
          end
        end
      end
    end
    
    line.tax_totals << TaxTotal.new.tap do |total|
      total.build_tax_amount do |amount|
        amount.currency = "PEN"
        amount.value = 17681
      end
      
      total.sub_totals << TaxSubTotal.new.tap do |subtotal|
        subtotal.build_tax_amount do |amount|
          amount.currency = "PEN"
          amount.value = 17681
        end
        subtotal.build_tax_category do |cat|
          cat.build_tax_scheme do |scheme|
            scheme.id = "1000"
            scheme.name = "IGV"
            scheme.tax_type_code = "VAT"
          end
        end
      end
    end
  end
end