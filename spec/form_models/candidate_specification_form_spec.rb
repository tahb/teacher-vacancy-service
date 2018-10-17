require 'rails_helper'
RSpec.describe CandidateSpecificationForm, type: :model do
  subject { CandidateSpecificationForm.new({}) }

  describe 'validations' do
    it {
      should validate_presence_of(:education)
        .with_message(I18n.t('activerecord.errors.models.vacancy.attributes.education.blank'))
    }
    it {
      should validate_presence_of(:qualifications)
        .with_message(I18n.t('activerecord.errors.models.vacancy.attributes.qualifications.blank'))
    }
    it {
      should validate_presence_of(:experience)
        .with_message(I18n.t('activerecord.errors.models.vacancy.attributes.experience.blank'))
    }
  end
end
