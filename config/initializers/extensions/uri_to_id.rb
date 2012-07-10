# ----------------------------------------------------------------------------------
# Search IDs from URIs
#
# This class is used to define the methods that from an URI are able to extract 
# the list of IDs that are used to connect a one resource to another
# ----------------------------------------------------------------------------------

module Lelylan
  module Search
    module URI

      # Gets all the ids starting from a list of URIs
      def find_resources(uris)
        uris.map { |uri| find_id_from_uri(uri) }
      end

      # Gets the id form the URI and raise error is the URI is nil
      def find_id_from_uri(uri)
        begin
          Addressable::URI.parse(uri).basename
        rescue
          raise Lelylan::Errors::ValidURI
        end
      end
    end
  end
end
