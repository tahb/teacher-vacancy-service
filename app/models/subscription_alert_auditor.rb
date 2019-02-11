class SubscriptionAlertAuditor < ApplicationRecord
  belongs_to :subscription
  enum status: %i[pending sent failed]

  scope :sent_today, -> { sent.find_by(date: Time.zone.now) }
end
