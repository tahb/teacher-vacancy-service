require 'rails_helper'

RSpec.describe SubscriptionAlertAuditor, type: :model do
  let(:subscription) { create(:subscription, frequency: :daily) }
  let(:auditor) { create(:subscription_alert_auditor, subscription: subscription) }

  it 'can have a subscription' do
    expect(auditor.subscription).to eq(subscription)
    expect(subscription.subscription_alert_auditors).to match_array([auditor])
  end

  context '#sent_today' do
    subject { described_class.sent_today }

    let!(:sent_today) do
      create(:subscription_alert_auditor, subscription: subscription, date: Time.zone.today, status: :sent)
    end

    let!(:sent_yesterday) do
      create(:subscription_alert_auditor, subscription: subscription, date: Time.zone.yesterday, status: :sent)
    end

    it 'returns the correct result' do
      expect(subject).to eq(sent_today)
    end
  end
end
