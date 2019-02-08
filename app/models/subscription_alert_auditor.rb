class SubscriptionAlertAuditor < ApplicationRecord
  belongs_to :subscription
  enum status: %i[pending sent failed]
end
