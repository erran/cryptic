require 'cryptic/exceptions'
require 'fileutils'
require 'openssl'

module Cryptic
  # Allow the use of shorthand error handling
  include Cryptic::Exceptions

  # A class that represents a private and public keypair
  #
  # @author Erran Carey <me@errancarey.com>
  class Keypair
    # Initializes a Cryptic::Keypair object from a private/public keypair
    #
    # @note The passphrase isn't saved
    # @todo Use the Ruby 2 named parameters syntax vs. an opts hash
    # @todo Validate that keys are public/private
    # @param [String] private_key the private key (or file) to use
    # @param [Hash] opts additional options to configure your Keypair with
    # @option opts [String] public_key the public key (or file) to use
    # @option opts [String] passphrase the passphrase to determine the public key
    #   from
    # @return [Keypair] the initialized Cryptic::Keypair object
    def initialize(private_key, opts = { public_key: nil, passphrase: nil })
      @private_key = OpenSSL::PKey::RSA.new(
                       if File.exists?(private_key)
                         File.read(private_key)
                       else
                         private_key
                       end,
                       opts[:passphrase]
                     )

      unless @private_key.private?
        raise(
          Cryptic::InvalidKey,
          "Public key '#{private_key}' provided as a private key."
        )
      end

      @public_key = OpenSSL::PKey::RSA.new(
                      if opts[:public_key] && File.exists?(opts[:public_key])
                        File.read(opts[:public_key])
                      elsif opts[:public_key]
                        opts[:public_key]
                      else
                        @private_key
                      end,
                      opts[:passphrase]
                    ).public_key
    rescue OpenSSL::PKey::RSAError => e
      if e.message.eql? 'Neither PUB key nor PRIV key:: not enough data'
        if @private_key.nil?
          raise Cryptic::InvalidKey, "Invalid private key: #{private_key}"
        elsif @public_key.nil?
          raise Cryptic::InvalidKey, "Invalid public key: #{public_key}"
        end
      elsif e.message.eql? 'Neither PUB key nor PRIV key:: nested asn1 error'
        raise Cryptic::IncorrectPassphrase, "Unable to open private key:
        '#{private_key}'. was the passphrase valid?"
      else
        raise e
      end
    end

    # Creates a keypair to be saved with #save
    #
    # @note The passphrase isn't saved
    # @param [String] passphrase the passphrase to give the private key
    # @param [Fixnum] size the amount of bits to use in your key
    # @return [Keypair] an object representing a private/public keypair
    def self.generate(passphrase = nil, size = 2048)
      # OPTIMIZE: There are so many hammers in here it looks like we're playing
      # Whack-a-mole
      # TODO: Find a better way to handle retries
      attempts ||= 0
      attempts += 1

      rsa_key = OpenSSL::PKey::RSA.new(size)
      cipher ||= OpenSSL::Cipher::AES256.new(:CBC)

      new(rsa_key.to_pem(cipher, passphrase), rsa_key.public_key.to_pem)
    rescue OpenSSL::PKey::RSAError => e
      if e.message =~ /^read key$/
        retry unless attempts > 1
      else
        raise e
      end
    end

    # Save the file
    #
    # @param [String] path the path to save the keypair into
    # @todo Document what save may raise
    # @todo Update this method
    # @return [String] returns the path files were saved to
    def save(path = '.')
      if @private_key.to_pem.eql?('') || @public_key.to_pem.eql?('')
        raise Cryptic::KeyGenerationFailure, "The keypair was never successfully generated"
      end

      FileUtils.mkdir_p(File.dirname(path))

      File.open("#{File.expand_path(path)}/cryptic_private.pem", 'w') do |file|
        file.write @private_key
      end

      File.open("#{File.expand_path(path)}/cryptic_public.pem", 'w') do |file|
        file.write @public_key
      end

      path
    end
  end
end
