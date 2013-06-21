require 'zip/zip'

module SUNAT
  module Delivery
    class Zipper
      def zip_xml(name, xml)
         zip = Zip::ZipOutputStream::write_buffer do
           zip.put_next_entry name
           zip.write xml
         end
         zip.rewind
         zip.sysread
      end
    end
    
    class Sender
          
      def initialize(name, document)
        @name = name
        @document = document
        @zipper = Zipper.new
      end
    
      # wrapper for prepare and send
      def send_document
        send(prepare)
      end
    
      def send(data)
        
      end
    
      def prepare
        byte_array zip
      end
    
      def zip
        @zipper.zip_xml(@name, @document)
      end
    
      def byte_array(zip_str)
        Base64.encode64(zip_str)
      end
    
      def wrap_for_soap(bytes)
        @soap_wrapper.wrap(bytes)
      end
    end
  end
end