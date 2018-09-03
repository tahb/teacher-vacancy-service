require 'rails_helper'
RSpec.feature 'Application statistics' do
  scenario 'a visitor to the website can view the application statistics' do
    job = create(:vacancy)
    5.times { Auditor::Audit.new(nil, 'dfe-sign-in.authentication.success', 'sample').log_without_association }
    2.times { Auditor::Audit.new(nil, 'dfe-sign-in.authorisation.failure', 'sample').log_without_association }
    Auditor::Audit.new(job, 'vacancy.publish', 'sample-id').log
    4.times { Auditor::Audit.new(job, 'vacancy.update', 'sample-id').log }

    visit stats_path

    within(".data[data-key='dfe-sign-in.authentication.success'] .data-item.bold-xxlarge") do
      expect(page).to have_content('5')
    end
    within(".data[data-key='dfe-sign-in.authentication.success'] .data-item.bold-xsmall") do
      expect(page).to have_content(
        I18n.t('statistics.dfe-sign-in.authentication.success', default: 'dfe-sign-in.authentication.success')
      )
    end

    within(".data[data-key='dfe-sign-in.authorisation.failure'] .data-item.bold-xxlarge") do
      expect(page).to have_content('2')
    end
    within(".data[data-key='dfe-sign-in.authorisation.failure'] .data-item.bold-xsmall") do
      expect(page).to have_content(
        I18n.t('statistics.dfe-sign-in.authorisation.failure', default: 'dfe-sign-in.authorisation.failure')
      )
    end

    within(".data[data-key='vacancy.publish'] .data-item.bold-xxlarge") do
      expect(page).to have_content('1')
    end
    within(".data[data-key='vacancy.publish'] .data-item.bold-xsmall") do
      expect(page).to have_content(
        I18n.t('statistics.vacancy.publish', default: 'vacancy.publish')
      )
    end

    within(".data[data-key='vacancy.update'] .data-item.bold-xxlarge") do
      expect(page).to have_content('4')
    end
    within(".data[data-key='vacancy.update'] .data-item.bold-xsmall") do
      expect(page).to have_content(
        I18n.t('statistics.vacancy.update', default: 'vacancy.update')
      )
    end
  end
end
