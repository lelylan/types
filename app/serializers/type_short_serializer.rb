class TypeShortSerializer < ApplicationSerializer
  cached true

  attributes :uri, :id, :name, :created_at, :updated_at
  has_many :properties, :functions, :statuses

  def uri
    TypeDecorator.decorate(object).uri
  end
end
