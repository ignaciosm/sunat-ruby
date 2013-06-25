# SUNAT Declaration Generator

Easily generate declarations for SUNAT, Peru's state tax collection entity.

## Installation

Add this line to your application's Gemfile:

    gem 'sunat'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sunat

## Usage

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


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
