class TypeSerializer < ApplicationSerializer
  cached true

  attributes :id, :uri, :owner, :name, :description, :category, :created_at, :updated_at
  has_many :properties, :functions, :statuses

  def uri
    TypeDecorator.decorate(object).uri
  end

  def owner
    { id: object.resource_owner_id, uri: object.decorate.resource_owner_uri }
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
