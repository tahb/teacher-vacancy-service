require 'rails_helper'
require 'performance_platform_sender'

RSpec.describe PerformancePlatformSender::Base do
  let(:type) { :transactions }

  let(:runtime) { Time.new(2008, 9, 1, 13, 0, 0).utc }
  let(:date_to_upload) { (Date.current.beginning_of_day.in_time_zone - 1.day).to_s }
  let(:parsed_date) { Time.zone.parse(date_to_upload) }

  subject { described_class.by_type(type) }

  it 'will return the correct class for type' do
    expect(subject).to be_a(PerformancePlatformSender::Transactions)
  end

  context 'transactions' do
    subject { described_class.by_type(type).call(date: date_to_upload) }

    it 'will submit transaction data' do
      Timecop.freeze(runtime) do
        stub_const('PP_TRANSACTIONS_BY_CHANNEL_TOKEN', 'not-nil')

        two_days_ago = Date.current.beginning_of_day.in_time_zone - 2.days
        today = Date.current.beginning_of_day.in_time_zone

        build(:vacancy, :past_publish, publish_on: two_days_ago).save(validate: false)
        build(:vacancy, :past_publish, publish_on: today).save(validate: false)

        jobs_published_yesterday = [
          build(:vacancy, :past_publish, publish_on: date_to_upload).save(validate: false),
          build(:vacancy, :past_publish, publish_on: date_to_upload).save(validate: false)
        ]

        transaction_by_channel = instance_double(PerformancePlatform::TransactionsByChannel)
        expect(PerformancePlatform::TransactionsByChannel)
          .to receive(:new).with('not-nil').and_return(transaction_by_channel)
        expect(transaction_by_channel).to receive(:submit).with(jobs_published_yesterday.count, parsed_date)

        subject

        expect(TransactionAuditor.last.success?).to be true
      end
    end

    it 'will be idempotent' do
      TransactionAuditor::Logger.new('performance_platform:submit_transactions', parsed_date).log_success

      expect(PerformancePlatform::TransactionsByChannel).to_not receive(:new)
      expect(Vacancy).to_not receive(:published_on_count)

      subject
    end

    it 'will log a failure' do
      allow_any_instance_of(PerformancePlatform::TransactionsByChannel)
        .to receive(:submit).and_raise(RuntimeError.new('Error'))

      expect { subject }.to raise_error(RuntimeError)

      expect(TransactionAuditor.last.success?).to be false
    end
  end

  context 'feedback' do
    let(:type) { :feedback }

    subject { described_class.by_type(type).call(date: date_to_upload) }

    it 'will submit feedback data' do
      stub_const('PP_USER_SATISFACTION_TOKEN', 'not-nil')

      today = Date.current.beginning_of_day.in_time_zone
      two_days_ago = today - 2.days

      create_list(:vacancy_publish_feedback, 3, rating: 1, created_at: today)
      create_list(:vacancy_publish_feedback, 4, rating: 4, created_at: two_days_ago)

      vacancy_publish_rating3 = create_list(:vacancy_publish_feedback, 3, rating: 3, created_at: date_to_upload)
      vacancy_publish_rating5 = create_list(:vacancy_publish_feedback, 5, rating: 5, created_at: date_to_upload)

      create_list(:general_feedback, 2, rating: 1, created_at: today)
      create_list(:general_feedback, 2, rating: 4, created_at: two_days_ago)

      general_rating3 = create_list(:general_feedback, 6, rating: 3, created_at: date_to_upload)
      general_rating5 = create_list(:general_feedback, 8, rating: 5, created_at: date_to_upload)

      ratings = {
        1 => 0,
        2 => 0,
        3 => vacancy_publish_rating3.count + general_rating3.count,
        4 => 0,
        5 => vacancy_publish_rating5.count + general_rating5.count
      }

      user_feedback = instance_double(PerformancePlatform::UserSatisfaction)
      expect(PerformancePlatform::UserSatisfaction)
        .to receive(:new).with('not-nil').and_return(user_feedback)
      expect(user_feedback).to receive(:submit).with(ratings, parsed_date)

      subject

      expect(TransactionAuditor.last.success?).to be true
    end
  end
end
