class Status
  include Mongoid::Document
  include Mongoid::Timestamps
  include Lelylan::Search::URI

  field :name
  field :created_from

  attr_accessor :properties
  attr_accessible :name, :properties

  validates :name, presence: true
  validates :created_from, presence: true, url: true

  embeds_many :status_properties, cascade_callbacks: true

  before_save :create_status_properties

  def create_status_properties
    if properties
      inject_id_to_hashes(properties, 'property_id')
      status_properties.destroy_all
      properties.each { |property| status_properties.build(property) }
    end
  end
end
