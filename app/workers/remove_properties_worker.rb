class RemovePropertiesWorker
  include Sidekiq::Worker

  def perform(type_id, property_ids)
    TypeWorker.remove(type_id, property_ids)
  end
end
