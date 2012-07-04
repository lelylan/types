class Category
  include Mongoid::Document
  include Mongoid::Timestamps

  field :created_from
  field :name
  field :public, type: Boolean, default: true

  has_and_belongs_to_many :typees

  attr_accessible :name, :public

  validates :name, presence: true
  validates :created_from, presence: true, url: true
  validates :public, inclusion: { in: [true, false] }
end
