# Attempt to connect twice the same resource
module Mongoid #:nodoc
  module Errors #:nodoc
   class Duplicated < MongoidError
      def initialize
        super(translate("duplicated",{}))
      end
    end
  end
end
