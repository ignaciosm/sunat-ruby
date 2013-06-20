module SUNAT
  module XMLBuilders    
    class PaymentDocumentBuilder < BasicBuilder
            
      QDT_NAMESPACE = 'urn:oasis:names:specification:ubl:schema:xsd:QualifiedDatatypes-2'
      UDT_NAMESPACE = 'urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2'
      CTC_NAMESPACE = 'urn:un:unece:uncefact:documentation:2'
      
      ADDITIONAL_ROOT_ATTRIBUTES = {
        'xmlns:ccts'  => CTC_NAMESPACE,
        'xmlns:qdt'   => QDT_NAMESPACE,
        'xmlns:udt'   => UDT_NAMESPACE
      }
      
      alias_method :invoice, :document
      
      def get_xml
        make_xml :Invoice do |xml|
          build_ubl_extensions xml
          build_general_data xml
          build_payment_general_data xml
          build_general_signature_information xml
          build_accounting_supplier_party xml
          build_accounting_customer_party xml
          build_tax_totals xml
          build_legal_monetary_total xml
          build_lines xml
        end
      end
      
      private
      
      def build_lines(xml)
        invoice.invoice_lines.each { |line| build_line xml, line }
      end
      
      def build_line(xml, line)
        xml['cac'].InvoiceLine do
          xml['cbc'].ID line.id
          
          build_quantity          xml, 'cbc', :InvoicedQuantity, line.invoiced_quantity
          build_money             xml, 'cbc', :LineExtensionAmount, line.line_extension_amount
          
          build_pricing_reference xml, line
          build_tax_totals        xml, line.tax_totals
          build_line_items        xml, line
          build_line_price        xml, line
        end
      end
      
      def build_quantity(xml, namespace, tag_name, quantity)
        xml[namespace].send(tag_name, { unitCode: quantity.unit_code }, quantity.quantity)
      end
      
      def build_pricing_reference(xml, line)
        ref = line.pricing_reference
        
        if ref.present?
          xml['cac'].PricingReference do
            ref.alternative_condition_prices.each do |alternative_condition_price|
              xml['cac'].AlternativeConditionPrice do
                build_money xml, 'cbc', :PriceAmount, alternative_condition_price.price_amount
                xml['cbc'].PriceTypeCode alternative_condition_price.price_type
              end
            end
          end
        end
      end

      def build_line_items(xml, line)
        line.items.each { build_item xml, item }
      end
      
      def build_item(xml, item)
        xml['cac'].Item do
          xml['cbc'].Description item.description
          xml['cac'].SellersItemIdentification do
            xml['cbc'].ID item.id
          end
        end
      end
      
      def build_line_price(xml, line)
        xml['cac'].Price do
          build_money xml, 'cbc', :PriceAmount, line.price
        end
      end
      
      def build_legal_monetary_total(xml)
        if invoice.legal_monetary_total.present?
          xml['cac'].LegalMonetaryTotal do
            build_money(xml, 'cbc', :PayableAmount, invoice.legal_monetary_total)
          end
        end
      end
      
      def build_payment_general_data(xml)        
        xml['cbc'].InvoiceTypeCode      invoice.invoice_type_code
        xml['cbc'].DocumentCurrencyCode invoice.document_currency_code
      end
    
      def additional_monetary_totals
        self.invoice.additional_monetary_totals
      end
    
      def additional_properties
        self.invoice.additional_properties
      end
    
      def build_additional_information_extension(xml)
        build_extension xml do
          xml['sac'].AdditionalInformation do
            additional_monetary_totals.each do |total|
              xml['sac'].AdditionalMonetaryTotal do
                xml['cbc'].ID total.id
                if total.payable_amount.present?
                  xml['cbc'].PayableAmount({currencyID: total.payable_amount.currency}, total.payable_amount.value)
                end
                if total.reference_amount.present?
                  xml['sac'].ReferenceAmount({currencyID: total.reference_amount.currency}, total.reference_amount.value)
                end
                if total.total_amount.present?
                  xml['sac'].TotalAmount({currencyID: total.total_amount.currency}, total.total_amount.value)
                end
                if total.percent.present?
                  xml['cbc'].Percent total.percent
                end
              end
            end
            additional_properties.each do |property|
              xml['sac'].AdditionalProperty do
                xml['cbc'].ID property.id
                xml['cbc'].Value property.value
                xml['cbc'].Name property.name
              end
            end
          end
        end
      end
      
    end
  end
end