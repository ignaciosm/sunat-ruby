### Steps

1. Generate the document:
  1. Build the document as an object.
  2. doc.to_xml
2. Sign the resulting document
  1. doc.sign
    1. Transform the BaseBuilder into a decorator of document responsible for generate the document without the signature called XMLDocument
    2. Create a new decorator called SignatureDocument, responsible for sign the document
3. Send the document
  1. doc.send
    1. Prepare
      1. Zip the document
      2. Transform document to a byte array
      3. Generate SOAP
    2. Send
      1. Send to endpoints