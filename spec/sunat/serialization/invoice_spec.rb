require 'spec_helper'

# for more succinct calls
include SUNAT

describe 'serialization of an invoice' do
  
  before :all do
    @invoice = Invoice.build do |i|
      i.id                      = "F002-10"
      i.invoice_type_code       = "01"
      i.document_currency_code  = "PEN"
      
      i.build_accounting_supplier_party do |asp|
        asp.account_id = "20100113612"
        asp.additional_account_id = "6"
        asp.build_party_with_name "K&G Laboratorios"
      end
      
      i.build_accounting_customer_party do |acp|
        acp.account_id = "20382170114"
        acp.additional_account_id = "6"
        acp.build_party_with_legal_name "CECI FARMA IMPORT S.R.L."
      end
      
      i.tax_totals << TaxTotal.build do |tt|
        tt.build_tax_amount do |amount|
          amount.value = 8745
          amount.currency = "PEN"
        end
        
        tt.sub_totals << TaxSubTotal.build do |st|
          st.build_tax_amount do |amount|
            amount.value = 26361
            amount.currency = "PEN"
          end

          st.build_tax_category do |cat|
            cat.tax_exemption_reason_code = "10"
            cat.build_tax_scheme do |scheme|
              scheme.id = "100"
              scheme.name = "IGV"
              scheme.tax_type_code = "VAT"
            end
          end
        end
      end
      
      i.invoice_lines << InvoiceLine.build do |il|
        il.id = "1"
                
        il.build_invoiced_quantity do |q|
          q.quantity = 300
          q.unit_code = "CS"
        end
        
        il.build_line_extension_amount do |amount|
          amount.value = 172890
          amount.currency = "PEN"
        end
        
        il.build_price do |p|
          p.value = 678
          p.currency = "PEN"
        end
        
        il.build_pricing_reference do |ref|
          ref.alternative_condition_prices << AlternativeConditionPrice.build do |acp|
            acp.price_type = "01"
            acp.build_price_amount do |amount|
              amount.value = 20
              amount.currency = "PEN"
            end
          end
        end
        
        il.tax_totals << TaxTotal.build do |tt|
          tt.build_tax_amount do |amount|
            amount.value = 26361
            amount.currency = "PEN"
          end
          
          tt.sub_totals << TaxSubTotal.build do |st|
            st.build_tax_amount do |amount|
              amount.value = 26361
              amount.currency = "PEN"
            end

            st.build_tax_category do |cat|
              cat.tax_exemption_reason_code = "10"
              cat.build_tax_scheme do |scheme|
                scheme.id = "100"
                scheme.name = "IGV"
                scheme.tax_type_code = "VAT"
              end
            end
          end
        end
        
        il.tax_totals << TaxTotal.build do |tt|
          
          tt.build_tax_amount do |amount|
            amount.value = 8745
            amount.currency = "PEN"
          end
          
          tt.sub_totals << TaxSubTotal.build do |st|
            st.build_tax_amount do |amount|
              amount.value = 8745
              amount.currency = "PEN"
            end

            st.build_tax_category do |cat|
              cat.tier_range = "02"
              cat.build_tax_scheme do |scheme|
                scheme.id = "2000"
                scheme.name = "ISC"
                scheme.tax_type_code = "EXC"
              end
            end
          end
        end
      end
    end
    
    @xml = Nokogiri::XML(@invoice.to_xml)
  end
  
  it "should create a //cbc:IssueDate tag with the the current date formatted as %Y-%m-%d" do
    date = @xml.xpath("//cbc:IssueDate")
    date.count.should >= 0
    date.text.should eq(Date.today.strftime("%Y-%m-%d"))
  end

end