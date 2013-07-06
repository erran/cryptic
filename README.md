# Cryptic
A Ruby gem for public key encryption, private key decryption, and generating key pairs.

## Installation
`gem install cryptic`

## Usage
### Command line

```
Commands:
  cryptic decrypt [PRIVATE_KEY] [ENCRYPTED_FILE] [OPTIONS]  # Decrypt a file with a private key
  cryptic encrypt [PUBLIC_KEY] [TEXT_FILE] [OPTIONS]        # Encrypt a file with a public key
  cryptic generate [OPTIONS]                                # Generate a private/public keypair
  cryptic help [COMMAND]                                    # Describe available commands or one specific command
```

### Ruby

```ruby
# Generate a keypair to use with a passphrase and the number of bits you'd like:
keypair = Cryptic::Keypair.new('P4$SpHr4z3', 2048)
keypair.save("#{ENV['HOME']}/.cryptic_keys")

private_key = keypair.private_key
public_key = keypair.public_key

# Encrypt a file:
data = File.read('foo.txt')
encrypted = Cryptic::EncryptedData.new(data, public_key)

# Returns an encrypted string you can save off to a file
encrypted.data

# To return the data call decrypt on the encrypted data object w/ the private key and passphrase
decrypted = encrypted.decrypt(private_key, 'P4$SpHr4z3')
```
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b feature/my-awesome-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-awesome-feature`)
5. Create new Pull Request
