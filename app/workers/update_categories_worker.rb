class UpdateCategoriesWorker
  include Sidekiq::Worker

  def perform(type_id, categories)
    TypeWorker.categories(type_id, categories)
  end
end
