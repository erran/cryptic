module Cryptic
  module Exceptions
    # A exception to throw if the the passphrase for a private key was entered
    # incorrectly
    #
    # @author Erran Carey <me@errancarey.com>
    class IncorrectPassphrase < ArgumentError; end
  end
end
