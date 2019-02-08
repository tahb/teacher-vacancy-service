FactoryBot.define do
  factory :subscription_alert_auditor do
    subscription { nil }
    date { Date.today }
    attempt { 0 }
    status { 0 }
  end
end
