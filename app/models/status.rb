class Status
  include Mongoid::Document
  include Mongoid::Timestamps
  include Lelylan::Document::Base

  field :name
  field :uri
  field :created_from
  field :default, type: Boolean, default: false
  field :image
  mount_uploader :image, ImageUploader

  attr_accessor :properties
  attr_accessible :name, :image, :properties

  embeds_many :status_properties

  validates :name, presence: true
  validates :uri, presence: true, url: true
  validates :created_from, presence: true, url: true

  before_save :create_status_properties


  # ---------------
  # Default status
  # ---------------

  # Create the default status for the new type instance
  def self.base_default(type, params, request, current_user)
    status = self.base(params, request, current_user)
    status.default!
    status.connect!(type)
    return status
  end

  # Return true if it is the default status, false otherwise
  def default?
    default
  end

  # Set the status as default
  def default!
    self.default = true
    save
  end

  # Connect the (default) status to the type
  def connect!(type)
    type.type_statuses.create(uri: uri, order: Settings.statuses.default_order)
  end


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
