class TypeShortSerializer < ApplicationSerializer
  cached true

  attributes :id, :uri, :name, :owner, :description, :created_at, :updated_at

  def uri
    TypeDecorator.decorate(object).uri
  end

  def owner
    { id: object.resource_owner_id, uri: object.decorate.resource_owner_uri }
  end
end
