class SubscriptionMailer < Mail::Notify::Mailer
  def confirmation(subscription_id)
    subscription = Subscription.find(subscription_id)

    @subscription_reference = subscription.reference
    @search_criteria = SubscriptionPresenter.new(subscription).filtered_search_criteria
    @expires_on = subscription.expires_on

    view_mail(
      NOTIFY_SUBSCRIPTION_CONFIRMATION_TEMPLATE,
      to: subscription.email,
      subject: "Teaching Vacancies subscription confirmation: #{subscription.reference}",
    )
  end

  def daily_alert(subscription_id, vacancy_ids)
    subscription = Subscription.find(subscription_id)
    vacancies = Vacancy.where(id: vacancy_ids)

    @email = subscription.email
    @subscription_reference = subscription.reference
    @expires_on = subscription.expires_on
    @unsubscribe_link = ''
    @vacancies = VacanciesPresenter.new(vacancies, searched: false)

    view_mail(
      NOTIFY_SUBSCRIPTION_DAILY_TEMPLATE,
      to: subscription.email,
      subject: I18n.t('subscriptions.email.daily.subject', count: vacancies.count),
    )
  end
end
