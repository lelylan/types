class AddPropertiesWorker
  include Sidekiq::Worker

  def perform(type_id, property_ids)
    TypeWorker.add(type_id, property_ids)
  end
end
