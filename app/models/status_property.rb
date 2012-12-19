class StatusProperty
  include Mongoid::Document
  include Mongoid::Timestamps
  include Resourceable

  field :property_id, type: Moped::BSON::ObjectId
  field :matches, type: Array, default: []

  attr_accessor :uri
  attr_protected :property_id

  validates :uri, presence: true, uri: true, on: :create

  embedded_in :status

  before_create :set_property_id, :parse_matches

  private

  def set_property_id
    self.property_id = find_id(uri)
  end

  def parse_matches
    self.matches.map!(&:to_s) if matches_changed?
  end
end
