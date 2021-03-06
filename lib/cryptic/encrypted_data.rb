require 'base64'
require 'openssl'
require 'cryptic/exceptions'

module Cryptic
  # Allow the use of shorthand error handling
  include Cryptic::Exceptions

  # A class with methods to encrypt/decrypt data
  #
  # @author Erran Carey <me@errancarey.com>
  class EncryptedData
    attr_reader :data
    attr_reader :encoding

    # Initializes the encrypted data object
    #
    # @note If called without a public key's file name this doesn't
    #   automatically encrypt the data
    # @param [String] data the data to encrypt
    # @param [String] public_key the  public key to use in # TODO: Update the indent right here
    #   the encryption process
    # @param [Symbol] encoding the encoding to use
    # @todo Document the opts hash
    # @todo Create an encrypt method to clean up this code
    # @raise [KeyNotFound] if the specified public key wasn't found on the
    #   file system
    # @return [EncryptedData] an encrypted data object
    def initialize(data, public_key = nil, encoding = :none, opts = {})
      @encoding = encoding

      if !public_key && !opts[:public_key_file]
        # If no public key was provided the data should already be encrypted
        @data = data
      elsif File.exists?(opts[:public_key_file].to_s)
        public_key = OpenSSL::PKey::RSA.new(File.read(public_key_file))
        encrypted_data = public_key.public_encrypt(data)
        @data = encode(encrypted_data)
      elsif public_key
        public_key = OpenSSL::PKey::RSA.new(public_key)
        encrypted_data = public_key.public_encrypt(data)
        @data = encode(encrypted_data)
      end
    end

    # Creates a new encrypted data object from an encrypted data string
    #
    # @param [String] data the encrypted data to load
    # @param [Symbol] encoding the encoding to use
    # @return [EncryptedData] an encrypted data object
    def self.load(data, encoding = :none)
      new(data, nil, encoding)
    end

    # Decrypts the data encrypted via a public key
    #
    # @note This doesn't have a partner encrypt method as the EncryptedData
    #   class encrypts data on initialization
    # @note The passphrase can be left nil in the case that you're using a
    #   terminal that will allow you to enter the passphrase when prompted
    # @param [String] private_key_file the private key to use during decryption
    # @param [String] passphrase the passphrase to unlock the private key with
    # @raise [KeyNotFound] if the specified public key wasn't found on the
    #   file system
    # @todo Use the opts syntax like in initialize
    # @todo Update the this method with encrypt in code cleanup
    # @return [String] the unencrypted data
    def decrypt(private_key_file, passphrase = nil)
      if File.exists?(private_key_file.to_s)
        private_key = OpenSSL::PKey::RSA.new(File.read(private_key_file), passphrase)
        decoded_string = decode(@data)
        private_key.private_decrypt(decoded_string)
      else
        private_key = OpenSSL::PKey::RSA.new(private_key_file, passphrase)
        decoded_string = decode(@data)
        private_key.private_decrypt(decoded_string)
      end
    rescue => e
      $stderr.puts e
      raise Cryptic::KeyNotFound
    end

    # @return [String] the encrypted data string
    def to_s; @data; end

    private # TODO: Determine whether to use private here or not

    # TODO: The decode/encode methods shouldn't share so much code
    # TODO: These methods also shouldn't raise an exception that could be raised
    #   earlier. Use something along the lines of:
    #   `SUPPORTED_ENCODING = [:base64, :none]` and checking whether the
    #   encoding supplied in initialize is included in it

    # Decode a string using the specified encoding
    #
    # @param [String] data the data to encode
    # @raise [UnsupportedEncoding] if the specified encoding isn't a valid
    # @return [String] the encoded data
    def decode(data)
      case @encoding
      when nil, :none, :raw
        data
      when :base64
        Base64.decode64(data)
      else
        raise Cryptic::UnsupportedEncoding, @encoding
      end
    end

    # Encode a string using the specified encoding
    #
    # @raise [UnsupportedEncoding] if the specified encoding isn't a valid
    #   encoding
    # @return [String] the unencoded data
    def encode(data)
      case @encoding
      when nil, :none, :raw
        data
      when :base64
        Base64.encode64(data)
      else
        raise Cryptic::UnsupportedEncoding, @encoding
      end
    end
  end
end
