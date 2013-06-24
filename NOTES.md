### Steps

1. Generate the document: [done]
  1. Build the document as an object. [done]
  2. doc.to_xml [done]
2. Sign the resulting document [done]
  1. doc.sign [done]
    1. Transform the BaseBuilder into a decorator of document responsible for generate the document without the signature called XMLDocument [done]
    2. Create a new decorator called SignatureDocument, responsible for sign the document [done]
3. Send the document
  1. doc.send
    1. Prepare
      0. Generate name of file
      1. Zip the document
      2. Transform document to a byte array
      3. Generate SOAP
    2. Send
      1. Send to endpoints