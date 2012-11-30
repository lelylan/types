class TypeShortSerializer < ApplicationSerializer
  cached true

  attributes :uri, :id, :name, :created_at, :updated_at

  def uri
    TypeDecorator.decorate(object).uri
  end
end
