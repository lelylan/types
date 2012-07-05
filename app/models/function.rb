class Function
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :created_from

  embeds_many :function_properties

  attr_accessor :properties
  attr_accessible :name, :properties

  validates :name, presence: true
  validates :created_from, presence: true, url: true

  before_save :extract_properties_id, :create_function_properties


  # extract the property id from its uri (for all property)
  def extract_properties_id
    properties.each do |property|
      property['property_id']  = Addressable::URI.parse(property['uri']).basename
    end
  end

  # create the properties
  def create_function_properties
      function_properties.destroy_all
      properties.each do |property|
        function_properties.build property
      end
  end
end
