require 'cryptic/exceptions'
require 'fileutils'
require 'openssl'

module Cryptic
  # Allow the use of shorthand error handling
  include Cryptic::Exceptions

  # A class that represents a private and public keypair
  #
  # @!attribute [String] private_key the contents of the private key file
  # @!attribute [String] public_key the contents of the public key file
  # @author Erran Carey <me@errancarey.com>
  class Keypair
    # Creates a keypair to be saved with #save
    #
    # @param [Fixnum] size the amount of bits to use in your key
    # @return [Keypair] an object representing a private/public keypair
    def initialize(passphrase = nil, size = 2048)
      @saved = false

      attempts ||= 0
      attempts += 1

      rsa_key = OpenSSL::PKey::RSA.new(size)
      cipher = OpenSSL::Cipher::AES256.new(:CBC)

      @private_key = rsa_key.to_pem(cipher, passphrase)
      @public_key = rsa_key.public_key.to_pem
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
    # @return [String] returns the path files were saved to
    def save(path = '.')
      if @private_key.to_s.eql?('') || @public_key.to_s.eql?('')
        raise Cryptic::KeyGenerationFailure, "The keypair was never successfully generated"
      end

      FileUtils.mkdir_p(File.dirname(path))

      File.open("#{File.expand_path(path)}/cryptic_private.pem", 'w') do |file|
        file.write @private_key
      end

      File.open("#{File.expand_path(path)}/cryptic_public.pem", 'w') do |file|
        file.write @public_key
      end

      @saved = true
      path
    end
  end
end
