require 'services/notify'
class SubscriptionDailyEmail
  include NotifyContentPresenter

  REFERENCE = 'subscription_daily_email'.freeze

  def initialize(subscription, vacancies)
    @email = subscription.email
    @subscription_reference = subscription.reference
    @expires_on = subscription.expires_on
    @unsubscribe_link = ''
    @vacancies = VacanciesPresenter.new(vacancies, searched: false)
  end

  def call
    Notify.new(email,
               personalisation,
               NOTIFY_SUBSCRIPTION_DAILY_TEMPLATE,
               REFERENCE).call
  end

  private

  attr_reader :email, :subscription_reference, :unsubscribe_link, :expires_on, :vacancies

  def personalisation
    {
      subscription_reference: subscription_reference,
      body: body
    }
  end

  def body
    @body = h2(I18n.t('app.title'))
    @body << h2(I18n.t('subscriptions.email.daily.summary', count: vacancies.count))
    @body << br
    @body << hr
    vacancies.each do |vacancy|
      list_vacancy(vacancy)
    end

    @body << add_line("Visit #{link_to(I18n.t('app.title'), 'https://teaching-vacancies.service.gov.uk')}")
    @body << link_to(I18n.t('subscriptions.email.daily.unsubscribe'), 'https://placeholder')
    @body
  end

  def list_vacancy(vacancy)
    @body << h2(link_to(vacancy.job_title, vacancy.share_url))
    @body << add_line(vacancy.school.name)
    @body << add_line("Salary: #{vacancy.salary_range}")
    @body << hr
  end
end
