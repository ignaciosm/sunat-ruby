require 'openssl'

module SUNAT
  module XMLBuilders    
    class InvoiceBuilder
      attr_accessor :invoice, :signature
      
      DATE_FORMAT = "%Y-%m-%d"
      
      C14N_ALGORITHM            = "http://www.w3.org/TR/2001/REC-xml-c14n-20010315"
      SIGNATURE_ALGORITHM       = "http://www.w3.org/2000/09/xmldsig#rsa-sha1"
      TRANSFORMATION_ALGORITHM  = "http://www.w3.org/2000/09/xmldsig#enveloped- signature"
      DIGEST_ALGORITHM          = "http://www.w3.org/2000/09/xmldsig#sha1"
      
      def initialize(invoice)
        self.invoice = invoice
        self.signature = build_signature
      end
      
      def get_xml        
        builder = xml_builder do |xml|
          build_root xml do
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
      
        builder.to_xml
      end
    
      private
      
      def build_signature
        SUNAT::SIGNATURE
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
      
      def build_accounting_party(xml, top_level_party)
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
      
      def format_date(date)
        date.strftime(DATE_FORMAT)
      end
      
      def xml_builder(&proc)
        # There is no way to add standalone=no without using with
        # see: http://goo.gl/jyJp4
        declaration = Nokogiri::XML('<?xml version="1.0" encoding="ISO-8859-1" standalone="no"?>')
        Nokogiri::XML::Builder.with(declaration, &proc)
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
            xml['cbc'].Id signature.party_id
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
    
      def build_root(xml, &block)
        attributes = {
          'xmlns'       => 'urn:oasis:names:specification:ubl:schema:xsd:Invoice-2',
          'xmlns:cac'   => 'urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2',
          'xmlns:cbc'   => 'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2',
          'xmlns:ccts'  => 'urn:un:unece:uncefact:documentation:2',
          'xmlns:ds'    => 'http://www.w3.org/2000/09/xmldsig#',
          'xmlns:ext'   => 'urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2',
          'xmlns:qdt'   => 'urn:oasis:names:specification:ubl:schema:xsd:QualifiedDatatypes-2',
          'xmlns:sac'   => 'urn:sunat:names:specification:ubl:peru:schema:xsd:SunatAggregateComponents-1',
          'xmlns:udt'   => 'urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2',
          'xmlns:xsi'   => 'http://www.w3.org/2001/XMLSchema-instance'
        }
        xml.Invoice(attributes, &block)
      end
    
      # TODO: STUB
      def additional_monetary_totals
        [
          { id: 1001, currency: "PEN", amount: 348199.15 },
          { id: 1003, currency: "PEN", amount: 12350.00 },
          { id: 2005, currency: "PEN", amount: 59230.51 }
        ]
      end
    
      # TODO: STUB
      def additional_properties
        [
          { id: 1000, value: "CUATROCIENTOS VEINTITRES MIL DOSCIENTOS VEINTICINCO Y 00/100" }
        ]
      end
    
      def build_extension(xml, &block)
        xml['ext'].UBLExtension do
          xml['ext'].ExtensionContent(&block)
        end
      end
    
      def build_additional_information_extension(xml)
        build_extension xml do
          xml['sac'].AdditionalInformation do
            additional_monetary_totals.each do |total|
              xml['sac'].AdditionalMonetaryTotal do
                xml['cbc'].ID total[:id]
                xml['cbc'].PayableAmount({currencyID: total[:currency]}, total[:amount])
              end
            end
            additional_properties.each do |property|
              xml['sac'].AdditionalProperty do
                xml['cbc'].ID property[:id]
                xml['cbc'].Value property[:value]
              end
            end
          end
        end
      end
    
      def build_signature_signed_info(xml)
        xml['ds'].SignedInfo do
          xml['ds'].CanonicalizationMethod(Algorithm: C14N_ALGORITHM)
          xml['ds'].SignatureMethod(Algorithm: SIGNATURE_ALGORITHM)
          xml['ds'].Reference(URI: "")
          xml['ds'].Transforms do
            xml['ds'].Transform(Algorithm: TRANSFORMATION_ALGORITHM)
          end
          xml['ds'].DigestMethod(Algorithm: DIGEST_ALGORITHM)
          xml['ds'].DigestValue '' # digest placeholder
        end
      end
    
      def build_signature_value(xml)
        xml['ds'].SignatureValue '' # signature base64 encoded placeholder
      end
    
      def build_signature_key_info(xml)
        xml['ds'].KeyInfo do
          xml['ds'].X509Data do
            certificate = signature.certificate
            xml['ds'].X509SubjectName certificate.issuer
            xml['ds'].X509Certificate certificate.cert
          end
        end
      end
    
      def build_signature_extension(xml)
        build_extension xml do
          xml['ds'].Signature(Id: signature.id) do
            build_signature_signed_info(xml)
            build_signature_value(xml)
            build_signature_key_info(xml)
          end
        end
      end
    
      def build_ubl_extensions(xml)
        xml['ext'].UBLExtensions do
          build_additional_information_extension(xml)
          build_signature_extension(xml)
        end
      end
      
    end
  end
end