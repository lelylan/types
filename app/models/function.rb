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

  after_save :create_function_properties


  # create the function properties in the embedded doc
  def create_function_properties
    if properties
      properties_id(properties)
      function_properties.destroy_all
      properties.each { |property| function_properties.create!(property) }
    end
  end


  private 

    def properties_id(properties)
      properties.each { |property| property['property_id'] = property_id(property) }
    end

    def property_id(property)
      begin
        property = HashWithIndifferentAccess.new property
        Addressable::URI.parse(property['uri']).basename
      rescue
        raise Lelylan::Errors::ValidURI
      end
    end
end
