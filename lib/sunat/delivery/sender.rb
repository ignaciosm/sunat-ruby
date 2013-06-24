module SUNAT
  module Delivery
    class Sender
      attr_reader :name, :encoded_zip, :operation, :client, :operation, :credentials
      
      WSDL = "https://www.sunat.gob.pe/ol-ti-itcpgem-sqa/billService?wsdl"
      
      def initialize(name, encoded_zip, operation)
        @operation = operation
        @encoded_zip = encoded_zip
        @name = name
      end
      
      def connect
        @client ||= new_client
      end
      
      def connect!
        @client = new_client
      end
      
      def auth_with(ruc, username, password)
        @credentials = OpenStruct.new.tap do |cred|
          cred.ruc = ruc
          cred.username = username
          cred.password = password
        end
      end
      
      def call        
        connect
        response = client.call operation, message: {
          fileName: "#{name}.zip",
          contentFile: encoded_zip
        }
        
        puts response.hash
        
        response
        
        # v3 #
        # 
        # @operation.body = {
        #   sendSummary: {
        #     fileName: "#{name}.zip",
        #     contentFile: encoded_zip
        #   }
        # }
        # @operation
        
        
        # puts operation.build
        # response = operation.call
        # response.hash
      end
      
      private
      
      def new_client
        raise "We need credentials object to be filled" if credentials.nil?
        
        username = credentials.ruc + credentials.username 
        password = credentials.password
        
        Savon.client(
          wsdl:             WSDL,
          wsse_auth:        [username, password],
          ssl_verify_mode:  :none
        )
      end
    end
  end
end