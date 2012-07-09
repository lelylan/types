class Function
  include Mongoid::Document
  include Mongoid::Timestamps
  include Lelylan::Search::URI

  field :name
  field :created_from

  attr_accessor :properties
  attr_accessible :name, :properties

  validates :name, presence: true
  validates :created_from, presence: true, url: true

  embeds_many :function_properties, cascade_callbacks: true

  before_save :reset_properties


  private 

    def reset_properties
      if properties
        function_properties.destroy_all
        properties.each do |property|
          property[:property_uri] = property[:uri]
          res = function_properties.create(property)
        end
      end
    end
end
