# SUNAT Declaration Generator

Easily generate declarations for SUNAT, Peru's state tax collection entity.

## Installation

Add this line to your application's Gemfile:

    gem 'sunat'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sunat

## Configuration

Prepare the SUNAT library by defining the configuration somewhere in your project as follows:

  SUNAT.configure do |config|
    config.credentials do |c|
      # Regular credentials provided by SUNAT
      c.ruc       = "123456780"
      c.username  = "USERNAME"
      c.password  = "PASSWORD"
    end
    
    config.signature do |s|
      # A company ID (Should be RUC)
      s.party_id    = "20100454523"

      # The name of the company
      s.party_name  = "SOPORTE TECNOLOGICO EIRL"

      # SUNAT validated certificate
      s.cert_file   = File.join(Dir.pwd, 'config', 'keys', 'sunat.crt')

      # Password-less private key used to sign certificate
      s.pk_file     = File.join(Dir.pwd, 'config', 'keys', 'sunat.key')
    end
  end




## Testing

Set the next ENV variables: SUNAT_RUC, SUNAT_USERNAME and SUNAT_PASSWORD.
They must be secret!

In Fish:

  set -gx SUNAT_RUC ruc # ruc
  set -gx SUNAT_USERNAME username # sol user
  set -gx SUNAT_PASSWORD password # sol password

In Bash:
  
  export SUNAT_RUC=ruc # ruc
  export SUNAT_USERNAME=username # sol user
  export SUNAT_PASSWORD=password # sol password


## Serialization

Every model can be serialized and de-serialized from JSON. This is extremely useful for storing a declaration a more readily usable form.


## Homologation

SUNAT requires that each document you'll be sending goes through an homologation process. See the examples directory for sample code that will help you get started.



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
