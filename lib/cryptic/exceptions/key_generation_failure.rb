module Cryptic
  module Exceptions
    # An generic exception that gets raised when key generation fails
    #
    # @author Erran Carey <me@errancarey.com>
    class KeyGenerationFailure < RuntimeError; end
  end
end
