# encoding: utf-8
module Mongoid #:nodoc
  module Errors #:nodoc
   class Duplicated < MongoidError
      def initialize
        super(translate("duplicated",{}))
      end
    end
  end
end
