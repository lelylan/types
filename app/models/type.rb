class Type
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :created_from
  field :public, default: 'true'

  field :property_ids, type: Array, default: []
  field :function_ids, type: Array, default: []

  attr_accessor :properties, :functions
  attr_accessible :name, :public, :properties, :functions

  validates :name, presence: true
  validates :created_from, presence: true, url: true
  validates :public, inclusion: { in: ['true', 'false'] }

  before_save :find_properties
  before_save :find_functions

  def find_properties
    self.property_ids = find_resources(properties) if not properties.nil?
  end

  def find_functions
    self.function_ids = find_resources(functions) if not functions.nil?
  end


  private

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

