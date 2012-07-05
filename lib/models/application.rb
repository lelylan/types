# TODO: temporary place, you should give a namespace and refactor

module Lelylan
  class Finder

    def find_resources(uris)
      uris.map { |uri| find_id_from_uri(uri) }
    end

    def find_id_from_uri(uri)
      begin
        Addressable::URI.parse(uri).basename
      rescue
        raise Lelylan::Errors::ValidURI
      end
    end
  end
end
