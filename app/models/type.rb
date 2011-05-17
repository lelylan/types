class Type
  include Mongoid::Document
  include Mongoid::Timestamps
  include Lelylan::Document::Base

  field :name
  field :uri
  field :created_from
  field :properties, type: Array, default: []
  field :functions, type: Array, default: []

  embeds_many   :type_statuses
  attr_accessor :statuses

  attr_accessible :name, :properties, :functions, :statuses

  validates :name, presence: true
  validates :uri, presence:true, url: true
  validates :created_from, presence: true, url: true

  before_save :create_type_statuses
  before_create :create_default_status

  private

    # Create the statuses into the embedding document.
    def create_type_statuses
      if statuses.is_a?(Array) and not statuses.empty?
        default = Settings.status.default_order
        type_statuses.clear
        statuses.each_with_index do |uri, order|
          type_statuses.build(uri: uri, order: order+1)
        end
      end
    end

    def create_default_status
    end
end
