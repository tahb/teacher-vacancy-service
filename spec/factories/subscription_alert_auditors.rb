FactoryBot.define do
  factory :subscription_alert_auditor do
    subscription { nil }
    date { Time.zone.today }
    attempt { 0 }
    status { 0 }
  end
end
