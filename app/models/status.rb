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

  def default?
    default == 'true'
  end

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
end
