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

  before_save :create_function_properties



  # create the properties
  def create_function_properties
    if properties
      extract_properties_id
      function_properties.destroy_all
      properties.each { |property| function_properties.build property }
    else
      puts "No properties was sent. Nothing is changing"
    end 
  end

  private 

    # extract the property id from its uri (for all property)
    def extract_properties_id
      properties.each do |property|
        property['property_id']  = Addressable::URI.parse(property['uri']).basename
      end
    end
end
