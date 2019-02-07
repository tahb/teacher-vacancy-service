require 'rails_helper'

RSpec.describe SubscriptionMailer, type: :mailer do
  let(:body_lines) { mail.body.raw_source.lines }
  let(:subscription) do
    create(:daily_subscription, email: 'an@email.com',
                                reference: 'a-reference',
                                search_criteria: {
                                  keyword: 'English',
                                  minimum_salary: 20000,
                                  maximum_salary: 40000,
                                  newly_qualified_teacher: 'true'
                                }.to_json)
  end

  describe 'confirmation' do
    before(:each) do
      stub_const('NOTIFY_SUBSCRIPTION_CONFIRMATION_TEMPLATE', '')
      Timecop.travel('2019-01-01')
    end

    after(:each) { Timecop.return }
    let(:mail) { SubscriptionMailer.confirmation(subscription.id) }

    it 'sends a confirmation email' do
      expect(mail.subject).to eq("Teaching Vacancies subscription confirmation: #{subscription.reference}")
      expect(mail.to).to eq([subscription.email])
      expect(body_lines[0]).to match(/# #{I18n.t('app.title')}/)
      expect(body_lines[1]).to match(/# #{subscription.reference}/)
      expect(body_lines[3]).to match(/#{I18n.t('subscriptions.email.confirmation.subheading')}/)
      expect(body_lines[5]).to match(/\* Keyword: English/)
      expect(body_lines[6]).to match(/\* Minimum Salary: £20,000/)
      expect(body_lines[7]).to match(/\* Maximum Salary: £40,000/)
      expect(body_lines[8]).to match(/\Suitable for NQTs/)
      expect(body_lines[10]).to match(/1 April 2019/)
    end
  end

  describe 'daily_alert' do
    before(:each) do
      stub_const('NOTIFY_SUBSCRIPTION_DAILY_TEMPLATE', '')
    end

    let(:mail) { SubscriptionMailer.daily_alert(subscription.id, vacancies.pluck(:id)) }

    context 'with a single vacancy' do
      let(:vacancies) { create_list(:vacancy, 1, :published) }
      let(:vacancy) { VacancyPresenter.new(vacancies.first) }

      it 'shows a vacancy' do
        expect(mail.subject).to eq(I18n.t('subscriptions.email.daily.subject.one'))
        expect(mail.to).to eq([subscription.email])

        expect(body_lines[0]).to match(/# #{I18n.t('app.title')}/)
        expect(body_lines[1]).to match(/# #{I18n.t('subscriptions.email.daily.summary.one')}/)
        expect(body_lines[3]).to match(/---/)
        expect(body_lines[5]).to match(/\[#{vacancy.job_title}\]\(#{vacancy.share_url}\)/)
        expect(body_lines[6]).to match(/#{vacancy.school_name}/)
        expect(body_lines[7]).to match(/Salary: #{vacancy.salary_range}/)
      end
    end

    context 'with multiple vacancies' do
      let(:vacancies) { create_list(:vacancy, 2, :published) }
      let(:first_vacancy) { VacancyPresenter.new(vacancies.first) }
      let(:second_vacancy) { VacancyPresenter.new(vacancies.last) }

      it 'shows vacancies' do
        expect(mail.subject).to eq(I18n.t('subscriptions.email.daily.subject.other', count: vacancies.count))
        expect(mail.to).to eq([subscription.email])

        expect(body_lines[5]).to match(/\[#{first_vacancy.job_title}\]\(#{first_vacancy.share_url}\)/)
        expect(body_lines[6]).to match(/#{first_vacancy.school_name}/)
        expect(body_lines[7]).to match(/Salary: #{first_vacancy.salary_range}/)

        expect(body_lines[9]).to match(/\[#{second_vacancy.job_title}\]\(#{second_vacancy.share_url}\)/)
        expect(body_lines[10]).to match(/#{second_vacancy.school_name}/)
        expect(body_lines[11]).to match(/Salary: #{second_vacancy.salary_range}/)
      end
    end
  end
end
