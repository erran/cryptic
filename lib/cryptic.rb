require 'cryptic/encrypted_data'
require 'cryptic/exceptions'
require 'cryptic/keypair'
require 'cryptic/version'

# A module to encrypt data using public keys
#
# @author Erran Carey <me@errancarey.com>
module Cryptic
  # Including Cryptic::Exceptions allows you to use shorthand for exceptions:
  # Cryptic::DecryptionError instead of Cryptic::Exceptions::DecryptionError
  include Cryptic::Exceptions
end
