module Cryptic
  module Exceptions
    # An exception to raise in the case of a key not being on the file system
    #
    # @author Erran Carey <me@errancarey.com>
    class KeyNotFound < Errno::ENOENT; end
  end
end
