class UpdatePropertyWorker
  include Sidekiq::Worker

  def perform(property_id, options)
    TypeWorker.updates(property_id, options)
  end
end
