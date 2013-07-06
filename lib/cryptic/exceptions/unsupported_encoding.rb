module Cryptic
  module Exceptions
    # An exception to raise when a valid encoding is specified
    #
    # @author Erran Carey <me@errancarey.com>
    class UnsupportedEncoding < EncodingError; end
  end
end
