require 'spec_helper'

describe 'serialization of an invoice' do

  # Create a "real world" document
  
  before :all do    
    @invoice = SUNAT::Invoice.new.tap do |i|
      i.id                      = "F002-10"
      i.invoice_type_code       = "01"
      i.document_currency_code  = "PEN"
      
      i.accounting_supplier_party = SUNAT::AccountingParty.new.tap do |asp|
        asp.account_id = "20100113612"
        asp.additional_account_id = "6"
        asp.party = SUNAT::Party.new.tap do |p|
          p.party_name = SUNAT::PartyName.new.tap do |pn|
            pn.name = "K&G Laboratorios"
          end
        end
      end
      
      i.accounting_customer_party = SUNAT::AccountingParty.new.tap do |acp|
        acp.account_id = "20382170114"
        acp.additional_account_id = "6"
        acp.party = SUNAT::Party.new.tap do |p|
          p.party_legal_entities << SUNAT::PartyLegalEntity.new.tap do |ple|
            ple.registration_name = "CECI FARMA IMPORT S.R.L."
          end
        end
      end
      
      i.invoice_lines << SUNAT::InvoiceLine.new.tap do |il|
        il.id = "1"
        
        il.invoiced_quantity = SUNAT::Quantity.new.tap do |iq|
          iq.quantity = 300
          iq.unit_code = "CS"
        end
        
        il.line_extension_amount = SUNAT::PaymentAmount.new.tap do |lea|
          lea.value = 172890
          lea.currency = "PEN"
        end
        
        il.price = SUNAT::Price.new.tap do |p|
          p.price_amount = SUNAT::PaymentAmount.new.tap do |pa|
            pa.value = 678
            pa.currency = "PEN"
          end
        end
        
        il.pricing_reference = SUNAT::PriceReference.new.tap do |pr|
          pr.alternative_condition_price = SUNAT::AlternativeConditionPrice.new.tap do |acp|
            acp.price_amount = SUNAT::PaymentAmount.new.tap do |pa|
              pa.value = 20
              pa.currency = "PEN"
            end
            acp.price_type = "01"
          end
        end
        
        il.tax_totals << SUNAT::TaxTotal.new.tap do |pa|
          
          pa.tax_amount = SUNAT::PaymentAmount.new.tap do |ta|
            ta.value = 26361
            ta.currency = "PEN"
          end
          
          pa.sub_totals << SUNAT::TaxSubTotal.new.tap do |st|
            st.tax_amount = SUNAT::PaymentAmount.new.tap do |pa|
              pa.value = 26361
              pa.currency = "PEN"
            end
            st.tax_category = SUNAT::TaxCategory.new.tap do |tc|
              tc.tax_exemption_reason_code = "10"
              tc.tax_scheme = SUNAT::TaxScheme.new.tap do |ts|
                ts.id = "100"
                ts.name = "IGV"
                ts.tax_type_code = "VAT"
              end
            end
          end
        end
        
        il.tax_totals << SUNAT::TaxTotal.new.tap do |pa|
          
          pa.tax_amount = SUNAT::PaymentAmount.new.tap do |ta|
            ta.value = 8745
            ta.currency = "PEN"
          end
          
          pa.sub_totals << SUNAT::TaxSubTotal.new.tap do |st|
            st.tax_amount = SUNAT::PaymentAmount.new.tap do |pa|
              pa.value = 8745
              pa.currency = "PEN"
            end
            st.tax_category = SUNAT::TaxCategory.new.tap do |tc|
              tc.tier_range = "02"
              tc.tax_scheme = SUNAT::TaxScheme.new.tap do |ts|
                ts.id = "2000"
                ts.name = "ISC"
                ts.tax_type_code = "EXC"
              end
            end
          end
        end
      end
    end
  end
  
  it "should be valid" do
    
  end
  
  it "should do nothing" do
    3.times { puts "**" * 5 }
    
    puts JSON.pretty_generate(@invoice.to_plain)
    
    3.times { puts "**" * 5 }
  end

end