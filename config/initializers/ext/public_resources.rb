module Lelylan
  module Resources
    module Public
      def self.included(base)
        base.send(:helper_method, :public_resource)
      end

      def allow_public_resources(*resources)
        if resources.include?(params[:controller])
          if %w(index show).include?(params[:action])
            @public_resource = true
            params[:action] == 'show' ? find_public_resource : find_public_resources
          end
        end
      end

      def public_resource
        @public_resource
      end

      private 

        def find_public_resource
          @resources = klass.where(public: true)
          @resource  = klass.where(public: true).where(_id: params[:id]).first
          return @resource ? true : false
        end

        def find_public_resources
          @resources = klass.where(public: true)
          return true
        end

        def klass
          params[:controller].singularize.capitalize.constantize
        end
    end
  end
end
