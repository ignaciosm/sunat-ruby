module SUNAT
  module Delivery
    class Sender
      attr_reader :name, :encoded_zip, :operation_list, :client, :operation
      
      WSDL = "https://www.sunat.gob.pe/ol-ti-itcpgem-sqa/billService?wsdl"
      
      def initialize(name, encoded_zip, operation_list)
        @operation_list = operation_list
        @encoded_zip = encoded_zip
        @name = name
      end
      
      def connect
        @client ||= Savon.new(WSDL)
      end
      
      def connect!
        @client = Savon.new(WSDL)
      end
      
      def build
        @operation = client.operation(*operation_list)
        @operation.body = {
          sendSummary: {
            fileName: name,
            contentFile: encoded_zip
          }
        }
        @operation
      end
      
      def send
        connect
        build
        response = operation.call
        puts response.hash
      end
    end
  end
end