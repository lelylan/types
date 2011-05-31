class Function
  include Mongoid::Document
  include Mongoid::Timestamps
  include Lelylan::Document::Base

  field :name
  field :uri
  field :created_from

  attr_accessor :properties
  attr_accessible :name, :properties

  embeds_many :function_properties

  validates :name, presence: true
  validates :uri, presence: true, url: true
  validates :created_from, presence: true, url: true

  before_save :create_function_properties


  # Enable the bulk assignment of properties to a function
  def create_function_properties
    if properties.is_a? Array
      function_properties.destroy_all
      validates_not_duplicated_uri
      function_properties = build_function_properties || []
    elsif not properties.nil?
      raise Mongoid::Errors::InvalidType.new(::Array, properties)
    end
  end


  private

    def build_function_properties
      properties.map do |property|
        function_property = function_properties.new(property)
        validate_function_property(function_property)
      end.compact!
    end

    def validates_not_duplicated_uri
      unless properties.length == properties.map{|p| p[:uri]}.uniq.length
        raise Mongoid::Errors::Duplicated.new
      end
    end

    def validate_function_property(function_property)
      unless function_property.valid?
        raise Mongoid::Errors::Validations.new(function_property)    
      end
    end
end
