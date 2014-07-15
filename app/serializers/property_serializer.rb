class PropertySerializer < ApplicationSerializer
  cached true

  attributes :id, :uri, :name, :type, :default, :accepted, :range, :created_at, :updated_at

  def uri
    PropertyDecorator.decorate(object).uri
  end

  def include_range?
    range
  end
end
