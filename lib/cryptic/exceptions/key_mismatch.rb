require 'cryptic/exceptions/decryption_error'

module Cryptic
  module Exceptions
    # An exception to raise when you try to decrypt with the wrong private key
    #
    # @author Erran Carey <me@errancarey.com>
    class KeyMismatch < DecryptionError; end
  end
end
