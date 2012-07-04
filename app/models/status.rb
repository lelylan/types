class Status
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :created_from
  field :image
  attr_accessor :properties
  #mount_uploader :image, ImageUploader

  has_and_belongs_to_many :typees
  embeds_many :status_properties

  attr_accessible :name, :properties #, :image


  validates :name, presence: true
  validates :created_from, presence: true, url: true

  before_save :create_status_properties


  # ----------------
  # Bulk assignment
  # ----------------

  # Enable bulk assignment of properties to a status
  def create_status_properties
    if properties.is_a? Array
      status_properties.destroy_all
      validates_not_duplicated_uri
      status_properties = build_status_properties || []
    elsif not properties.nil?
      raise Mongoid::Errors::InvalidType.new(::Array, properties)
    end
  end


  private

    # Build a new stauts property without saving it. In this way 
    # we can check if it is valid or not.
    def build_status_properties
      properties.map do |property|
        status_property = status_properties.new(property)
        validate_status_property(status_property)
      end.compact!
    end

    # Raise an error if the status property connection is not valid
    def validates_not_duplicated_uri
      unless properties.length == properties.map{|p| p[:uri]}.uniq.length
        raise Mongoid::Errors::Duplicated.new
      end
    end

    # Raise an error if the same uri is inserted twice. 
    def validate_status_property(status_property)
      unless status_property.valid?
        raise Mongoid::Errors::Validations.new(status_property)    
      end
    end
end
