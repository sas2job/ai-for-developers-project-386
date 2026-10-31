class Booking < ApplicationRecord
  belongs_to :event_type

  validates :guest_name, :guest_email, :starts_at, :ends_at, presence: true
  validates :guest_email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :ends_at, comparison: { greater_than: :starts_at }
end
