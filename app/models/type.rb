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

  def connected_properties
    Property.any_in(uri: properties).where(created_from: created_from)
  end

  def connected_functions
    Function.any_in(uri: functions).where(created_from: created_from)
  end

  def connected_statuses(with_default=false)
    Status.any_in(uri: statuses_uri(with_default)).where(created_from: created_from)
  end

  def statuses_uri(with_default=false)
    list = type_statuses.asc('order')
    list = type_statuses.excludes(order: Settings.statuses.default_order) unless with_default
    list.collect(&:uri)
  end

  private

    # Create the statuses into the embedding document. It does
    # not delete the default status and raise an errorsimilar to 
    # the one given from MongoID when a wrong tipe is given
    def create_type_statuses
      if statuses.is_a?(Array)
        delete_type_statuses_except_default
        create_type_statuses_from(statuses)
      elsif not statuses.nil?
        raise Mongoid::Errors::InvalidType.new(::Array, statuses)
      end
    end

    def delete_type_statuses_except_default
      type_statuses.excludes(order: Settings.statuses.default_order).delete_all
    end

    def create_type_statuses_from(statuses)
      statuses.each_with_index do |uri, order|
        type_statuses.build(uri: uri, order: order+1)
      end
    end
end
