require 'rails_helper'

RSpec.describe SubscriptionAlertAuditor, type: :model do
  let(:subscription) { create(:subscription, frequency: :daily)}
  let(:auditor) { create(:subscription_alert_auditor, subscription: subscription)}

  it 'can have a subscription' do
    expect(auditor.subscription).to eq(subscription)
    expect(subscription.subscription_alert_auditors).to match_array([auditor])
  end
end
