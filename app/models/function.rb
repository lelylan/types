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
      properties_id(properties)
      function_properties.destroy_all
      properties.each { |property| function_properties.build property }
    else
      puts "No properties was sent. Nothing is changing"
    end 
  end

  private 

    # extract the property id from its uri (for all property)
    def properties_id(properties)
      properties.each { |property| property['property_id'] = property_id(property) }
    end

    def property_id(property)
      begin
        Addressable::URI.parse(property['uri']).basename
      rescue
        raise Lelylan::Errors::ValidURI
      end
    end
end
