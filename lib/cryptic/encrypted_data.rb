require 'base64'
require 'openssl'
require 'cryptic/exceptions'

module Cryptic
  # Allow the use of shorthand error handling
  include Cryptic::Exceptions

  # A class with methods to encrypt/decrypt data
  #
  # @!attribute [Symbol] encoding the encoding to use
  # @!attribute [String] data the encrypted data string
  # @author Erran Carey <me@errancarey.com>
  class EncryptedData
    attr_reader :data
    attr_reader :encoding

    # Initializes the encrypted data object
    #
    # @note If called without a public key's file name this doesn't
    #   automatically encrypt the data
    # @param [String] data the data to encrypt
    # @param [String] public_key_file the filename of the public key to use in
    #   the encryption process
    # @param [Symbol] encoding the encoding to use
    # @raise [KeyNotFound] if the specified public key wasn't found on the
    #   file system
    # @return [EncryptedData] an encrypted data object
    def initialize(data, public_key_file = nil, encoding = :none)
      @encoding = encoding

      if !public_key_file
        # If no public key was provided the data should already be encrypted
        @data = data
      elsif File.exists? public_key_file.to_s
        public_key = OpenSSL::PKey::RSA.new(File.read(public_key_file))
        encrypted_data = public_key.public_encrypt(data)
        @data = encode(encrypted_data)
      else
        raise KeyNotFound
      end
    end

    # Creates a new encrypted data object from an encrypted data string
    #
    # @param [String] data the encrypted data to load
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
    def decrypt(private_key_file, passphrase = nil)
      if File.exists? private_key_file.to_s
        private_key = OpenSSL::PKey::RSA.new(File.read(private_key_file), passphrase)
        decoded_string = decode(@data)
        private_key.private_decrypt(decoded_string)
      else
        raise KeyNotFound
      end
    end

    # @return [String] the encrypted data string
    def to_s; @data; end

    private

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
