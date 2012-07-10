class Category
  include Mongoid::Document
  include Mongoid::Timestamps

  field :created_from
  field :name

  attr_accessible :name

  validates :name, presence: true
  validates :created_from, presence: true, url: true
end
