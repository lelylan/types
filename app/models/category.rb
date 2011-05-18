class Category
  include Mongoid::Document
  include Mongoid::Timestamps
  include Lelylan::Document::Base

  field :name
  field :uri
  field :created_from

  attr_accessible :name
  
  validates :name, presence: true
  validates :uri, presence: true, url: true
  validates :created_from, presence: true, url: true
end
