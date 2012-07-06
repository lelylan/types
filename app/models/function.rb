class Function
  include Mongoid::Document
  include Mongoid::Timestamps
  include Lelylan::Search::URI  # used for inect_id_to_hashes

  field :name
  field :created_from

  attr_accessor :properties
  attr_accessible :name, :properties

  validates :name, presence: true
  validates :created_from, presence: true, url: true

  embeds_many :function_properties

  after_save :create_function_properties

  def create_function_properties
    if properties
      inject_ids(properties, 'property_id')
      function_properties.destroy_all
      properties.each { |property| function_properties.create!(property) }
    end
  end
end
