class Function
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :created_from

  embeds_many :function_properties

  attr_accessible :name, :properties

  validates :name, presence: true
  validates :created_from, presence: true, url: true

  before_save :create_function_properties


  # property creation
  def create_function_properties
      function_properties.destroy_all
      function_properties.each do |function_property|
        function_properties.create! function_property
      end
  end
end
