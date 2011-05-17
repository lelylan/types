class Status
  include Mongoid::Document
  include Mongoid::Timestamps
  include Lelylan::Document::Base

  field :name
  field :uri
  field :created_from
  field :message, default: ''
  field :default, default: 'false'
  field :image
  mount_uploader :image, ImageUploader

  attr_accessible :name, :message, :image, :remote_image_url

  embeds_many :status_properties

  validates :name, presence: true
  validates :uri, presence: true, url: true
  validates :created_from, presence: true, url: true


  # Rturn true if it is the default status, false otherwise
  def default?
    default == 'true'
  end

  # Create the default status for the new type instance
  def self.base_default(type, params, request, current_user)
    status = self.base(params, request, current_user)
    status.default!
    status.connect!(type)
    return status
  end

  def default!
    self.default = true
    save
  end

  def connect!(type)
    type.type_statuses.create(uri: uri, order: Settings.statuses.default_order)
  end


  # Find the matching status representing a specific device
  def self.find_matching_status(properties, statuses) 
    result = []
    statuses.each do |status|
      passed = [true]
      passed += status.status_properties.collect do |status_property|
        puts "::::examine::::#{status_property.uri} with values #{status_property.values.inspect} pending #{status_property.pending}"
        property = properties.find {|p| p.has_value?(status_property.uri) }
        match_conditions?(status_property, property)
      end
      puts "::::elaborated #{status.name} with results #{passed.inspect} (complessive #{passed.inject(:&)})" 
      result << status if passed.inject(:&)
    end
    return result
  end

  private

    def self.match_conditions?(status_property, property)
      puts "::::::MATCH VALUE" + match_value?(status_property, property).inspect
      puts "::::::MATCH PENDING" + match_pending?(status_property, property).inspect

      match_value?(status_property, property) and match_pending?(status_property, property)
    end

    def self.match_value?(status_property, property)

      status_property.values.include?(property[:value]) or status_property.values.empty?
    end

    def self.match_pending?(status_property, property)
      puts "::::PENDING DETAILS STATUS:::" + status_property.pending.inspect
      puts "::::GRRRRRRRRR" + property.inspect
      puts "::::PENDING DETAILS device:::" + property[:pending].inspect

      status_property.pending == property[:pending].to_s or status_property.pending.empty?
    end
end
