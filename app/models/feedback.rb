class Feedback < ApplicationRecord
  belongs_to :vacancy
  validates :rating, presence: { message: I18n.t('activerecord.errors.models.feedback.attributes.rating.blank') }

  scope :published_on, (->(date) { where('date(created_at) = ?', date) })
end
