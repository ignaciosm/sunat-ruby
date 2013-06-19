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
          build_general_signature_information xml
          build_accounting_supplier_party xml
          build_accounting_customer_party xml
          build_tax_totals xml
          build_legal_monetary_total xml
          build_lines xml
        end
      end
      
      private
      
      def build_party_physical_location(xml, party)
        # implements if necesary.
      end
      
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
      
      def build_money(xml, namespace, tag_name, money)
        xml[namespace].send(tag_name, { currencyID: money.currency }, money.value)
      end
      
      def build_total(xml, namespace, tag_name, total)
        xml[namespace].send(tag_name) do
          build_money xml, 'cbc', :TaxAmount, total.tax_amount
        end
        
        sub_totals = total.sub_totals
        
        if sub_totals.any?
          sub_totals.each do |sub_total|
            xml['cac'].TaxSubTotal do
              build_money(xml, 'cbc', :TaxAmount, sub_total.tax_amount)
              
              category = sub_total.tax_category
              
              xml['cac'].TaxCategory do
                scheme = category.tax_scheme
                
                xml['cbc'].TaxExemptionReasonCode(category.tax_exemption_reason_code) if category.tax_exemption_reason_code
                xml['cbc'].TierRange(category.tier_range) if category.tier_range
                
                xml['cac'].TaxScheme do
                  xml['cbc'].ID           scheme.id
                  xml['cbc'].Name         scheme.name
                  xml['cbc'].TaxTypeCode  scheme.tax_type_code
                end
              end
            end
          end
        end
      end
      
      def build_tax_totals(xml, totals = invoice.tax_totals)
        totals.each do |total|
          build_total xml, 'cac', :TaxTotal, total
        end
      end
      
      def build_accounting_party(xml, top_level_party, &continuation)
        xml['cbc'].CustomerAssignedAccountID top_level_party.account_id
        xml['cbc'].AdditionalAccountID top_level_party.additional_account_id
        
        party = top_level_party.party
        
        xml['cac'].Party do
          
          if party.name.present?
            xml['cac'].PartyName do
              xml['cbc'].Name party.name
            end
          end
          
          if party.postal_addresses.any?
            party.postal_addresses.each do |address|
              xml['cac'].PostalAddress do
                xml['cbc'].ID                   address.id
                xml['cbc'].StreetName           address.street_name
                xml['cbc'].CitySubdivisionName  address.city_subdivision_name
                xml['cbc'].CountrySubentity     address.country_subentity
                xml['cbc'].District             address.district
                xml['cac'].Country do
                  xml['cbc'].IdentificationCode address.country.identification_code
                end
              end
            end
          end
          
          if party.party_legal_entities.any?
            party.party_legal_entities do |entity|
              xml['cac'].PartyLegalEntity do
                xml['cbc'].RegistrationName entity.registration_name
              end
            end
            build_party_physical_location xml, party
          end
        end
      end
      
      def build_accounting_customer_party(xml)        
        xml['cac'].AccountingCustomerParty do
          build_accounting_party xml, invoice.accounting_customer_party
        end
      end
      
      def build_accounting_supplier_party(xml)        
        xml['cac'].AccountingSupplierParty do
          build_accounting_party xml, invoice.accounting_supplier_party
        end
      end
      
      def build_general_data(xml)
        xml['cbc'].UBLVersionID "2.0"
        xml['cbc'].CustomizationID      invoice.customization_id
        xml['cbc'].ID                   invoice.id
        xml['cbc'].IssueDate            format_date(invoice.issue_date)
        xml['cbc'].InvoiceTypeCode      invoice.invoice_type_code
        xml['cbc'].DocumentCurrencyCode invoice.document_currency_code
      end
      
      def build_general_signature_information(xml)
        xml['cac'].Signature do
          xml['cbc'].ID 'IDSignKG' # id of the signature
        end
        
        xml['cac'].SignatoryParty do
          xml['cac'].PartyIdentification do
            xml['cbc'].ID signature.party_id
          end
          xml['cac'].PartyName do
            xml['cbc'].Name signature.party_name
          end
        end
        
        xml['cac'].DigitalSignatureAttachment do
          xml['cac'].ExternalReference do
            xml['cbc'].URI signature.uri
          end
        end
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