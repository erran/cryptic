# Cryptic [![Build Status](https://secure.travis-ci.org/ipwnstuff/cryptic.png)](http://travis-ci.org/ipwnstuff/cryptic) [![Dependency Status](https://gemnasium.com/ipwnstuff/cryptic.png)](https://gemnasium.com/ipwnstuff/cryptic)
A Ruby gem for public key encryption, private key decryption, and generating key pairs.

## Languages
For documentation in other languages look around in [locales/files](locales/files) to find a README marked with your laungage code.
If you can speak multiple languages then feel free add a new one!

## Documentation
http://www.rubydoc.info/github/ipwnstuff/cryptic

## Installation
Just run: `gem install cryptic` or add `gem 'cryptic'` to your Gemfile.

## Usage
### Command line

```
[ecarey @ cryptic]$ cryptic
Commands:
  cryptic decrypt [PRIVATE_KEY] [ENCRYPTED_FILE] [OPTIONS]  # Decrypt a file with a private key
  cryptic encrypt [PUBLIC_KEY] [TEXT_FILE] [OPTIONS]        # Encrypt a file with a public key
  cryptic generate [OPTIONS]                                # Generate a private/public keypair
  cryptic help [COMMAND]                                    # Describe available commands or one specific command
```

### Ruby

```ruby
require 'cryptic'

# Load a keypair to use:
keypair = Cryptic::Keypair.new('cryptic_private.pem', public_key: 'cryptic_public.pem')

# Obtain your public/private keys from the `Cryptic::Keypair` object:
private_key = keypair.private_key
public_key = keypair.public_key

# Encrypt a file:
data = File.read('foo.txt')
encrypted = Cryptic::EncryptedData.new(data, public_key, :base64)

# Returns an encrypted string you can save off to a file:
encrypted.data

# To return the data call decrypt on the encrypted data object w/ the private key and passphrase:
decrypted = encrypted.decrypt(private_key, 'P4$SpHr4z3', :base64)
```
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b feature/my-awesome-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-awesome-feature`)
5. Create new Pull Request
