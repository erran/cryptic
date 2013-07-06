module Cryptic
  module Exceptions
    # A exception to throw if the encrypted data looks bogus
    #
    # @author Erran Carey <me@errancarey.com>
    class InvalidData < ArgumentError; end
  end
end
