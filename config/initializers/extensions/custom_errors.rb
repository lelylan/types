module Lelylan #:nodoc
  module Errors #:nodoc

   class Time < StandardError
      def initialize(options={})
        message = ::I18n.translate("notifications.query.time_message", options)
        super(message)
      end
    end

    class ValidURI < StandardError
      def initialize(options={})
        message = ::I18n.translate("notifications.errors.uri", options)
        super(message)
      end
    end
  end
end
