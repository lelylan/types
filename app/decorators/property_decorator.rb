class PropertyDecorator < ApplicationDecorator
  decorates :Property

  def uri
    puts "CREATING URI: " + model.inspect
    puts "CREATING URI: " + default_options.inspect

    h.property_path(model, default_options)
  end
end
