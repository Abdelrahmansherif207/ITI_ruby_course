# == Schema Information
#
# Table name: articles
#
#  id            :integer          not null, primary key
#  body          :text
#  reports_count :integer
#  status        :string
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :integer          not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class Article < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  # Validations
  validates :title, presence: true
  validates :body, presence: true
  validates :reports_count, numericality: { greater_than_or_equal_to: 0 }

  # Callbacks
  before_save :check_reports_count
  after_initialize :set_default_values, if: :new_record?

  # Scopes
  scope :reported, -> { where("reports_count >= ?", 3) }
  scope :heavily_reported, -> { where("reports_count >= ?", 6) }
  scope :published, -> { where(status: 'published') }
  scope :archived, -> { where(status: 'archived') }

  private

  def check_reports_count
    if reports_count.to_i >= 3 && status != 'archived'
      self.status = 'archived'
    end
  end

  def set_default_values
    self.reports_count ||= 0
    self.status ||= 'published'
  end
end
