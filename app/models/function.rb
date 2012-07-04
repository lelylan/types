class Function
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :created_from

  has_and_belongs_to_many :typees
  embeds_many :function_properties

  attr_accessible :name, :properties

  validates :name, presence: true
  validates :created_from, presence: true, url: true

  before_save :create_function_properties


  # ----------------
  # Bulk assignment
  # ----------------

  # Enable bulk assignment of properties to a function
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

    # Build a new function property without saving it. In this way 
    # we can check if it is valid or not.
    def build_function_properties
      properties.map do |property|
        function_property = function_properties.new(property)
        validate_function_property(function_property)
      end.compact!
    end

    # Raise an error if the function property connection is not valid
    def validate_function_property(function_property)
      unless function_property.valid?
        raise Mongoid::Errors::Validations.new(function_property)    
      end
    end

    # Raise an error if the same uri is inserted twice. 
    def validates_not_duplicated_uri
      unless properties.length == properties.map{|p| p[:uri]}.uniq.length
        raise Mongoid::Errors::Duplicated.new
      end
    end
end
