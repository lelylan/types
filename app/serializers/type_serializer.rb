class TypeSerializer < ApplicationSerializer
  cached true

  attributes :uri, :id, :name, :created_at, :updated_at
  has_many :properties, :functions, :statuses

  def uri
    TypeDecorator.decorate(object).uri
  end

  def properties
    Property.in(id: object.property_ids)
  end

  def functions
    Function.in(id: object.function_ids)
  end

  def statuses
    Status.in(id: object.status_ids)
  end
end
