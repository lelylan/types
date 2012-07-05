class Status
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :created_from

  attr_accessor :properties
  attr_accessible :name, :properties

  validates :name, presence: true
  validates :created_from, presence: true, url: true

  embeds_many :status_properties

  before_save :create_status_properties

  def create_status_properties
    if properties
      uris = properties.map { |property| HashWithIndifferentAccess.new(property)[:uri] }
      find_resources()
    end
  end

end
