module VacancyHelpers
  def fill_in_job_specification_form_fields(vacancy)
    fill_in 'job_specification_form[job_title]', with: vacancy.job_title
    fill_in 'job_specification_form[job_description]', with: vacancy.job_description
    select vacancy.min_pay_scale.label, from: 'job_specification_form[min_pay_scale_id]'
    select vacancy.max_pay_scale.label, from: 'job_specification_form[max_pay_scale_id]'
    select vacancy.subject.name, from: 'job_specification_form[subject_id]'
    select vacancy.first_supporting_subject, from: 'job_specification_form[first_supporting_subject_id]'
    select vacancy.second_supporting_subject, from: 'job_specification_form[second_supporting_subject_id]'
    select vacancy.leadership.title, from: 'job_specification_form[leadership_id]'
    check 'job_specification_form[newly_qualified_teacher]' if vacancy.newly_qualified_teacher
    fill_in 'job_specification_form[minimum_salary]', with: vacancy.minimum_salary
    fill_in 'job_specification_form[maximum_salary]', with: vacancy.maximum_salary
    fill_in 'job_specification_form[benefits]', with: vacancy.benefits
    fill_in 'job_specification_form[starts_on_dd]', with: vacancy.starts_on.day
    fill_in 'job_specification_form[starts_on_mm]', with: vacancy.starts_on.strftime('%m')
    fill_in 'job_specification_form[starts_on_yyyy]', with: vacancy.starts_on.year
    fill_in 'job_specification_form[ends_on_dd]', with: vacancy.ends_on.day
    fill_in 'job_specification_form[ends_on_mm]', with: vacancy.ends_on.strftime('%m')
    fill_in 'job_specification_form[ends_on_yyyy]', with: vacancy.ends_on.year

    fill_in 'job_specification_form[weekly_hours]', with: vacancy.weekly_hours if vacancy.weekly_hours?

    vacancy.model_working_patterns.each do |working_pattern|
      check Vacancy.human_attribute_name("working_patterns.#{working_pattern}"),
            name: 'job_specification_form[working_patterns][]'
    end
  end

  def fill_in_candidate_specification_form_fields(vacancy)
    fill_in 'candidate_specification_form[education]', with: vacancy.education
    fill_in 'candidate_specification_form[qualifications]', with: vacancy.qualifications
    fill_in 'candidate_specification_form[experience]', with: vacancy.experience
  end

  def fill_in_application_details_form_fields(vacancy)
    fill_in 'application_details_form[contact_email]', with: vacancy.contact_email
    fill_in 'application_details_form[application_link]', with: vacancy.application_link

    fill_in 'application_details_form[expires_on_dd]', with: vacancy.expires_on.day
    fill_in 'application_details_form[expires_on_mm]', with: vacancy.expires_on.strftime('%m')
    fill_in 'application_details_form[expires_on_yyyy]', with: vacancy.expires_on.year

    fill_in 'application_details_form[publish_on_dd]', with: vacancy.publish_on.day
    fill_in 'application_details_form[publish_on_mm]', with: vacancy.publish_on.strftime('%m')
    fill_in 'application_details_form[publish_on_yyyy]', with: vacancy.publish_on.year
  end

  def fill_in_copy_vacancy_form_fields(vacancy)
    fill_in 'copy_vacancy_form[job_title]', with: vacancy.job_title

    fill_in 'copy_vacancy_form[starts_on_dd]', with: vacancy.starts_on.day
    fill_in 'copy_vacancy_form[starts_on_mm]', with: vacancy.starts_on.strftime('%m')
    fill_in 'copy_vacancy_form[starts_on_yyyy]', with: vacancy.starts_on.year

    fill_in 'copy_vacancy_form[ends_on_dd]', with: vacancy.ends_on.day
    fill_in 'copy_vacancy_form[ends_on_mm]', with: vacancy.ends_on.strftime('%m')
    fill_in 'copy_vacancy_form[ends_on_yyyy]', with: vacancy.ends_on.year

    fill_in 'copy_vacancy_form[expires_on_dd]', with: vacancy.expires_on&.day
    fill_in 'copy_vacancy_form[expires_on_mm]', with: vacancy.expires_on&.strftime('%m')
    fill_in 'copy_vacancy_form[expires_on_yyyy]', with: vacancy.expires_on&.year

    fill_in 'copy_vacancy_form[publish_on_dd]', with: vacancy.publish_on&.day
    fill_in 'copy_vacancy_form[publish_on_mm]', with: vacancy.publish_on&.strftime('%m')
    fill_in 'copy_vacancy_form[publish_on_yyyy]', with: vacancy.publish_on&.year
  end

  def verify_all_vacancy_details(vacancy)
    expect(page).to have_content(vacancy.job_title)
    expect(page.html).to include(vacancy.job_description)
    expect(page).to have_content(vacancy.subject.name)
    expect(page).to have_content(vacancy.other_subjects)
    expect(page).to have_content(vacancy.salary_range)
    expect(page).to have_content(vacancy.working_patterns)
    expect(page.html).to include(vacancy.flexible_working) if vacancy.flexible_working?
    expect(page).to have_content(vacancy.newly_qualified_teacher)
    expect(page.html).to include(vacancy.benefits)
    expect(page).to have_content(vacancy.pay_scale_range)
    expect(page).to have_content(vacancy.starts_on)
    expect(page).to have_content(vacancy.ends_on)

    expect(page.html).to include(vacancy.education)
    expect(page.html).to include(vacancy.qualifications)
    expect(page.html).to include(vacancy.experience)
    expect(page).to have_content(vacancy.leadership.title)

    expect(page).to have_content(vacancy.contact_email)
    expect(page).to have_content(vacancy.application_link)
    expect(page).to have_content(vacancy.expires_on)
    expect(page).to have_content(vacancy.publish_on)

    if vacancy.weekly_hours?
      expect(page).to have_content(vacancy.weekly_hours)
    elsif vacancy.weekly_hours.present?
      expect(page).not_to have_content(vacancy.weekly_hours)
    end
  end

  def verify_vacancy_show_page_details(vacancy)
    expect(page).to have_content(vacancy.job_title)
    expect(page.html).to include(vacancy.job_description)
    expect(page).to have_content(vacancy.subject.name)
    expect(page).to have_content(vacancy.other_subjects)
    expect(page).to have_content(vacancy.salary_range)
    expect(page).to have_content(vacancy.working_patterns)
    expect(page.html).to include(vacancy.flexible_working) if vacancy.flexible_working?
    expect(page).to have_content(vacancy.newly_qualified_teacher)
    expect(page.html).to include(vacancy.benefits)
    expect(page).to have_content(vacancy.pay_scale_range)
    expect(page).to have_content(vacancy.starts_on)
    expect(page).to have_content(vacancy.ends_on)

    expect(page.html).to include(vacancy.education)
    expect(page.html).to include(vacancy.qualifications)
    expect(page.html).to include(vacancy.experience)
    expect(page).to have_content(vacancy.leadership.title)

    expect(page).to have_link(I18n.t('jobs.apply'), href: new_job_interest_path(vacancy.id))
    expect(page).to have_content(vacancy.expires_on)
    expect(page).to have_content(vacancy.publish_on)

    if vacancy.weekly_hours?
      expect(page).to have_content(vacancy.weekly_hours)
    elsif vacancy.weekly_hours.present?
      expect(page).not_to have_content(vacancy.weekly_hours)
    end
  end

  def verify_vacancy_list_page_details(vacancy)
    expect(page.find('.vacancy')).to have_content(vacancy.job_title)
    expect(page.find('.vacancy')).to have_content(vacancy.salary_range)
    expect(page.find('.vacancy')).to have_content(vacancy.expires_on)
    expect(page.find('.vacancy')).to have_content(vacancy.publish_on)
    expect(page.find('.vacancy')).to have_content(vacancy.starts_on)
    expect(page.find('.vacancy')).to have_content(vacancy.working_patterns)
  end

  def expect_schema_property_to_match_value(key, value)
    expect(page).to have_selector("meta[itemprop='#{key}'][content='#{value}']")
  end

  def skip_vacancy_publish_on_validation
    allow_any_instance_of(Vacancy).to receive(:publish_on_must_not_be_in_the_past).and_return(true)
  end

  def vacancy_json_ld(vacancy)
    json = {
      '@context': 'http://schema.org',
      '@type': 'JobPosting',
      'title': vacancy.job_title,
      'jobBenefits': vacancy.benefits,
      'datePosted': vacancy.publish_on.to_time.iso8601,
      'description': vacancy.job_description,
      'educationRequirements': vacancy.education,
      'qualifications': vacancy.qualifications,
      'experienceRequirements': vacancy.experience,
      'employmentType': vacancy.working_patterns_for_job_schema,
      'industry': 'Education',
      'jobLocation': {
        '@type': 'Place',
        'address': {
          '@type': 'PostalAddress',
          'addressLocality': vacancy.school.town,
          'addressRegion': vacancy.school.region.name,
          'streetAddress': vacancy.school.address,
          'postalCode': vacancy.school.postcode,
        },
      },
      'url': job_url(vacancy),
      'baseSalary': {
        '@type': 'MonetaryAmount',
        'currency': 'GBP',
        value: {
          '@type': 'QuantitativeValue',
          'minValue': vacancy.minimum_salary,
          'maxValue': vacancy.maximum_salary,
          'unitText': 'YEAR'
        },
      },
      'hiringOrganization': {
        '@type': 'School',
        'name': vacancy.school.name,
        'identifier': vacancy.school.urn,
      },
      'validThrough': vacancy.expires_on.end_of_day.to_time.iso8601,
    }

    json['workHours'] = vacancy.weekly_hours if vacancy.weekly_hours?
    json
  end
end
