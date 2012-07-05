class Typee
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :created_from
  field :public, default: 'true'

  attr_accessor :properties
  attr_accessible :name, :public, :properties

  validates :name, presence: true
  validates :created_from, presence: true, url: true
  validates :public, inclusion: { in: ['true', 'false'] }

  before_save :find_properties_id

  def find_properties_id
    self.properties = find_id(properties)
  end


  private

    def find_id(uris)
      uris.map do |uri|
        begin
          Addressable::URI.parse(uri).basename
        rescue
          raise Lelylan::Errors::ValidURI
        end
      end
    end
end
