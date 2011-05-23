module Lelylan
  module Resources
    module Public
      def self.included(base)
        base.send(:helper_method, :public_resource)
      end

      def allow_public_resources(resources)
        if resources.include?(params[:controller])
          if %w(index show).include?(params[:action])
            @public_resource = true
          end
        end
      end

      # Returns true if you can access to the action without authorization
      def accessing_public_resource?
        @public_resource
      end

      # Take a resource and check if the user (auhtenticated or not can access
      # or not it). It give back 4xx status if something is not allowed.
      def check_for_public_or_owned_resource(resource)
        if resource
          if not resource.public
            if current_user 
              if not resource.created_from == current_user.uri
                render_404 'notifications.document.not_found', {id: params[:id]}
              end
            else
              render_401
            end
          end
        else
          render_404 'notifications.document.not_found', {id: params[:id]}
        end
      end

    end
  end
end
