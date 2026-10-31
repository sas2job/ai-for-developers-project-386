class EventType < ApplicationRecord
  validates :name, :description, presence: true
  validates :duration_minutes, numericality: { only_integer: true, greater_than: 0 }
end
