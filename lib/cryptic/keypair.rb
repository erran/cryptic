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
    # Creates a keypair to be saved with #save or #save!
    #
    # @param [Fixnum] size the amount of bits to use in your key
    # @param [Fixnum] exponent the exponent to use when generating your key
    # @return [Keypair] an object representing a private/public keypair
    def initialize(size = 2048, exponent = 65537)
      keypair = OpenSSL::PKey::RSA.generate(size, exponent)

      @private_key = keypair.to_s
      @public_key = keypair.public_key.to_s
    end

    # Saves the private and public keypair
    #
    # @param [String] path the path to save the keypair into
    # @return [false,String] returns false on failure and returns the path
    #   parameter on success
    def save(path = '.')
      FileUtils.mkdir_p(File.dirname(path))

      File.open("#{path}/cryptic_private.pem", File::WRONLY|File::CREAT|File::EXCL) do |file|
          file.write @private_key
      end

      File.open('cryptic_public.pem', File::WRONLY|File::CREAT|File::EXCL) do |file|
          file.write @public_key
      end

      path
    rescue SystemCallError => e
      $stderr.puts e
      false
    end

    # Forcefully saves the private and public keys and allows exceptions to be
    # raised
    #
    # @param [String] path the path to save the keypair into
    # @todo Document what save! will raise
    # @return [String] returns the path files were saved to
    def save!(path = '.')
      FileUtils.mkdir_p(File.dirname(path))

      File.open("#{path}/cryptic_private.pem", 'w') do |file|
        file.write @private_key
      end

      File.open("#{path}/cryptic_public.pem", 'w') do |file|
        file.write @public_key
      end

      path
    end
  end
end
