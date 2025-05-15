# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :mentioning, class_name: 'Mention', foreign_key: 'report_from_id', dependent: :destroy, inverse_of: :report_to
  has_many :mentioning_reports, through: :mentioning, source: :report_to

  has_many :mentioned, class_name: 'Mention', foreign_key: 'report_to_id', dependent: :destroy, inverse_of: :report_from
  has_many :mentioned_reports, through: :mentioned, source: :report_from

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end
end
