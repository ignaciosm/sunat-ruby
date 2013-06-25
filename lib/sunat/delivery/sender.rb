HTTPI.adapter = :net_http

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
        need_credentials do
          connect
          response = client.call operation, message: {
            fileName: "#{name}.zip",
            contentFile: encoded_zip
          }
          response
        end
      end
      
      private
      
      def new_client        
        username = credentials.username
        password = credentials.password
        
        Savon.client(
          wsdl:               WSDL,
          wsse_auth:          [username, password],
          ssl_cert_file:      cert_file,
          ssl_cert_key_file:  pk_file,
          ssl_version:        :SSLv3
        )
      end
      
      def cert_file
        SUNAT::SIGNATURE.cert_file
      end
      
      def pk_file
        SUNAT::SIGNATURE.pk_file
      end
      
      def need_credentials
        if credentials.nil?
          raise "We need credentials object to be filled"
        else
          yield
        end
      end
    end
  end
end