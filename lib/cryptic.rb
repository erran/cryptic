require 'cryptic/encrypted_data'
require 'cryptic/exceptions'
require 'cryptic/version'

# A module to encrypt data using public keys
#
# @author Erran Carey <me@errancarey.com>
module Cryptic
  # This allows you to call methods by a shorthand name such as
  # Cryptic::DecryptionError instead of Cryptic::Exceptions::DecryptionError
  include Cryptic::Exceptions
end
