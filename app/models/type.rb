class Type
  include Mongoid::Document
  include Mongoid::Timestamps
  include Lelylan::Document::Base

  field :name
  field :uri
  field :created_from
  field :public, type: Boolean, default: false
  field :categories, type: Array, default: []
  field :properties, type: Array, default: []
  field :functions, type: Array, default: []

  attr_accessor :statuses
  embeds_many :type_statuses
  before_save :create_type_statuses

  attr_accessible :name, :properties, :functions, :statuses, :categories, :public

  validates :name, presence: true
  validates :uri, presence:true, url: true
  validates :created_from, presence: true, url: true
  validates :public, inclusion: { in: [true, false] }


  def connected_categories
    Category.any_in(uri: categories)
  end

  def connected_properties
    Property.any_in(uri: properties)
  end

  def connected_functions
    Function.any_in(uri: functions)
  end

  # Get the status resources and order them. Mongoid do not
  # retrieve documents following the key order.
  def connected_statuses(with_default=false)
    statuses_uri(with_default)
    statuses = Status.any_in(uri: statuses_uri(with_default)).to_a
    statuses_uri(with_default).collect do |uri|
      statuses.find { |status| status.uri == uri }
    end
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
