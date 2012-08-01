module Lelylan
  module Errors
    module Helpers

      def self.included(base)
        base.rescue_from Mongoid::Errors::DocumentNotFound, with: :document_not_found
        base.rescue_from Mongoid::Errors::Validations,      with: :document_not_valid
        base.rescue_from MultiJson::DecodeError,            with: :json_error
      end

      def document_not_found
        render_404 'notifications.resource.not_found'
      end

      def document_not_valid(e)
        render_422 'notifications.resource.not_valid', e.message
      end

      def json_error(e)
        code = 'notifications.json.not_valid'
        render_422 code, I18n.t(code)
      end

      # ----------------
      # View rendering
      # ----------------

      def doorkeeper_unauthorized_render_options
        { template: 'shared/401', :status => :unauthorized }
      end

      def render_404(code = 'notifications.resource.not_found', uri = nil)
        @code  = code
        @error = I18n.t(code)
        @uri   = uri || request.url
        render 'shared/404', status: 404 and return
      end

      def render_422(code, error)
        @body  = json_body
        @code  = code
        @error = error
        render 'shared/422', status: 422 and return
      end

      private

      def json_body
        key  = request.path_parameters[:controller].singularize
        json = request.request_parameters
        json[key]
      end
    end
  end
end
