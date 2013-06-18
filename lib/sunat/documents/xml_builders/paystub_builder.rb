module SUNAT
  module XMLBuilders
    class PaystubBuilder < PaymentDocumentBuilder
      def build_party_physical_location(xml, party)
        return if party.physical_location.nil?
        
        xml['cac'].PhysicalLocation do
          xml['cbc'].Description party.physical_location.description
        end
      end
    end
  end
end