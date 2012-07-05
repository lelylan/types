class Typee
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :created_from
  field :public, default: 'true'

  has_and_belongs_to_many :properties
  has_and_belongs_to_many :functions
  #has_and_belongs_to_many :categories
  #has_and_belongs_to_many :statuses

  attr_accessible :name, :public, :properties, :functions

  validates :name, presence: true
  validates :created_from, presence: true, url: true
  validates :public, inclusion: { in: ['true', 'false'] }

  before_save :properties_id
  before_save :functions_id

  def find_properties_id
    self.properties = find_id(properties)
  end

  def find_functions_id
    slef.functions = find_id(functions)
  end

  private

    # TODO: move in a lib or initializer
    def find_id(uris)
      uris.map do |uri|
        begin
          Addressable::URI.parse(property['uri']).basename
        rescue
          raise Lelylan::Errors::ValidURI
        end
      end
    end
end
