object PropertyDecorator.decorate(@property)

node(:uri)        { |c| c.uri }
node(:id)         { |c| c.id }
node(:name)       { |c| c.name }
node(:default)    { |c| c.default }
node(:values)     { |c| c.values }
node(:created_at) { |c| c.created_at }
node(:updated_at) { |c| c.updated_at }
