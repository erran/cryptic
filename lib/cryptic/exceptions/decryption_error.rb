require 'cryptic/exceptions/encryption_error'

module Cryptic
  module Exceptions
    # An exception to throw when there's a problem with decryption
    #
    # @author Erran Carey <me@errancarey.com>
    class DecryptionError < EncryptionError; end
  end
end
