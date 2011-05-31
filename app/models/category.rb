class Category
  include Mongoid::Document
  include Mongoid::Timestamps
  include Lelylan::Document::Base

  field :name
  field :uri
  field :created_from
  field :public, type: Boolean, default: false

  attr_accessible :name, :public
  
  validates :name, presence: true
  validates :uri, presence: true, url: true
  validates :created_from, presence: true, url: true
  validates :public, inclusion: { in: [true, false] }
end
