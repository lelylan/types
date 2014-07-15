class UpdateCategoryWorker
  include Sidekiq::Worker

  def perform(type_id, category)
    TypeWorker.category(type_id, category)
  end
end
