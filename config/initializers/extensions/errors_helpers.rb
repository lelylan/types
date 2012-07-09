module Lelylan
  module Errors
    module Helpers

      # ---------
      # Rescue
      # ---------

      def self.included(base)
        base.rescue_from Mongoid::Errors::DocumentNotFound, with: :document_not_found
        base.rescue_from Mongoid::Errors::Validations, with: :document_not_valid
        base.rescue_from JSON::ParserError, with: :json_parse_error
        base.rescue_from Lelylan::Errors::Time, with: :lelylan_errors_time
        base.rescue_from Lelylan::Errors::ValidURI, with: :lelylan_errors_uri
      end

      # Document not found
      def document_not_found
        render_404 "notifications.resource.not_found"
      end

      # Document not valid
      def document_not_valid(e)
        render_422 "notifications.resource.not_valid", e.message, clean_body
      end

      # Parsing error on JSON body
      def json_parse_error(e)
        code = "notifications.json.not_valid" 
        render_422 code, I18n.t(code), dirty_body
      end

      # Wrong time format
      def lelylan_errors_time(e)
        code = "notifications.query.time"
        render_422 code, I18n.t(code), e.message
      end

      # Wrong uri format
      # TODO: find a way to write only the wrong URI if possible
      # On tie error seems there is a way to send some params.
      def lelylan_errors_uri(e)
        code = "notifications.errors.uri_message"
        render_422 code, I18n.t(code)
      end

      # ----------------
      # View rendering
      # ----------------

      # Not authorized
      def render_401
        render 'shared/401', status: 401 and return
      end

      # Not found
      def render_404(code = 'notifications.resource.not_found', uri=nil)
        @code  = code
        @error = I18n.t(code)
        @uri   = uri || request.url
        render "shared/404", status: 404 and return
      end

      # Not valid
      def render_422(code, error, body=nil)
        @body = body || clean_body
        @code = code
        @error = error.is_a?(String) ? error : error.full_messages.join('. ')
        render "shared/422", status: 422 and return
      end

      private 

        def parse_error(e)
          e.message
        end

        # Body content as JSON
        def clean_body
          body = request.request_parameters
          # Hack to have a clean JSON. Not sure why, but it creates an hash where the 
          # key is the params and the value is null. With this cicle we clean it up.
          body.each_key {|key| body = JSON.parse key }
          body
        end

        # Body JSON as string
        def dirty_body
          body = request.request_parameters
          # Hack to have a clean JSON. Not sure why, but it creates an hash where the 
          # key is the params and the value is null. With this cicle we clean it up.
          body.each_key {|key| body = key }
          body
        end
    end
  end
end
