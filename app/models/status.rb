class Status
  include Mongoid::Document
  include Mongoid::Timestamps
  include Lelylan::Document::Base

  field :name
  field :uri
  field :created_from
  field :template, default: ""
  field :default, default: "false"
  field :order, type: Integer
  field :icon_uid
  image_accessor :icon

  attr_accessible :name, :template, :order

  embed_many :status_properties
  validates_associated :status_properties

  validates :name, presence: true
  validates :uri, url: true
  validates :created_from, url: true

  validates_size_of :icon, :maximum => 500.kilobytes
  validates_property :format, :of => :icon, :in => [:png]
  validates_property :mime_type, :of => :icon, :in => %w(image/png)
  validates_property :width, :of => :icon, :in => (0..512)
  validates_property :height, :of => :icon, :in => (0..512)

  def properties_uri
    self.uri + "/proeprties"
  end

  def self.base(params, request, credentials)
    resource = super
    resource.icon  = self.default_icon
    resource.order = resource.next_order
    return resource
  end

  def self.base_default(params, request, credentials)
    resource = self.base(params, request, credentials)
    resource.default = "true"
    resource.order = 0
    resource.save
    return resource
  end

  def self.default_icon
    image = Rails.root.join("public", "images", "devices", "default.png")
    File.new(image)
  end

  def default?
    self.default == "true"
  end

  # TODO: make a real incremental method and to check the right 
  # place where it should live
  def next_order
    self.order = self.status_properties.length
  end

end
