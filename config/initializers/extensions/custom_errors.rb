module Lelylan
  module Errors
   class Time < StandardError
      def initialize(options={})
        message = ::I18n.translate("notifications.query.time_message", options)
        super(message)
      end
    end
  end
end
