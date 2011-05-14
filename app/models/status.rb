class Status
  include Mongoid::Document
  include Mongoid::Timestamps
  include Lelylan::Document::Base

  field :name
  field :uri
  field :created_from
  field :template, default: ''
  field :default, default: 'false'
  field :image
  mount_uploader :image, ImageUploader

  attr_accessible :name, :template, :image, :remote_image_url

  embeds_many :status_properties

  validates :name, presence: true
  validates :uri, presence: true, url: true
  validates :created_from, presence: true, url: true
end
