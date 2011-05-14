class Status
  include Mongoid::Document
  include Mongoid::Timestamps
  include Lelylan::Document::Base

  field :name
  field :uri
  field :created_from
  field :template, default: ''
  field :default, default: 'false'
  field :order, type: Integer
  field :image
  mount_uploader :image, ImageUploader

  attr_accessible :name, :template, :order, :image, :remote_image_url

  embeds_many :status_properties

  validates :name, presence: true
  validates :uri, presence: true, url: true
  validates :created_from, presence: true, url: true


  def self.base(params, request, credentials)
    resource = super
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

  def default?
    self.default == "true"
  end

  # TODO: make a real incremental method and to check the right 
  # place where it should live
  def next_order
    self.order = self.status_properties.length
  end

end
