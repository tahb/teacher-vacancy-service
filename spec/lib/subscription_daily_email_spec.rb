require 'rails_helper'
require 'subscription_daily_email'

RSpec.describe SubscriptionDailyEmail do
  before(:each) do
    stub_const('NOTIFY_SUBSCRIPTION_DAILY_TEMPLATE', '')
  end

  let(:subscription) { create(:daily_subscription, email: 'example@email.com', reference: 'a-reference') }
  let(:notify_mock) { double(:notify, call: nil) }

  it 'correctly generates the email content for one search result' do
    vacancy = create(:vacancy, :published)
    presenter = VacancyPresenter.new(vacancy)
    vacancies = [vacancy]
    personalisation = { subscription_reference: subscription.reference,
                        body: "# Teaching Vacancies\n# #{vacancies.count} new jobs matching your " \
                        'search criteria were ' \
                        "posted yesteday.\n\n\n---\n" \
                        "# [#{vacancy.job_title}](#{presenter.share_url})\n" \
                        "#{vacancy.school.name}\n" \
                        "Salary: #{presenter.salary_range}\n\n---\n" \
                        "Visit [Teaching Vacancies](https://teaching-vacancies.service.gov.uk)\n" \
                        '[Follow this link to unsubscribe.](https://placeholder)' }

    expect(Notify).to receive(:new).with(subscription.email, personalisation, '', 'subscription_daily_email')
                                   .and_return(notify_mock)

    SubscriptionDailyEmail.new(subscription, vacancies).call
  end

  it 'correctly generates the email content for multiple search results' do
    vacancies = create_list(:vacancy, 4, :published)
    vacancies = vacancies.map { |v| VacancyPresenter.new(v) }

    personalisation = { subscription_reference: subscription.reference,
                        body: "# Teaching Vacancies\n# #{vacancies.count} new jobs matching your " \
                        'search criteria were ' \
                        "posted yesteday.\n\n\n---\n" \
                        "# [#{vacancies[0].job_title}](#{vacancies[0].share_url})\n" \
                        "#{vacancies[0].school.name}\n" \
                        "Salary: #{vacancies[0].salary_range}\n\n---\n" \
                        "# [#{vacancies[1].job_title}](#{vacancies[1].share_url})\n" \
                        "#{vacancies[1].school.name}\n" \
                        "Salary: #{vacancies[1].salary_range}\n\n---\n" \
                        "# [#{vacancies[2].job_title}](#{vacancies[2].share_url})\n" \
                        "#{vacancies[2].school.name}\n" \
                        "Salary: #{vacancies[2].salary_range}\n\n---\n" \
                        "# [#{vacancies[3].job_title}](#{vacancies[3].share_url})\n" \
                        "#{vacancies[3].school.name}\n" \
                        "Salary: #{vacancies[3].salary_range}\n\n---\n" \
                        "Visit [Teaching Vacancies](https://teaching-vacancies.service.gov.uk)\n" \
                        '[Follow this link to unsubscribe.](https://placeholder)' }

    expect(Notify).to receive(:new).with(subscription.email, personalisation, '', 'subscription_daily_email')
                                   .and_return(notify_mock)

    SubscriptionDailyEmail.new(subscription, vacancies).call
  end
end
