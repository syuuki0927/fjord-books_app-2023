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

  def save_with_mentions
    result = false
    transaction do
      result = save! && update_mentions!
    end

    result
  end

  def update_with_mentions(params)
    result = false
    transaction do
      result = update!(params) && update_mentions!
    end

    result
  end

  private

  def update_mentions!
    mentioning_ids = content.scan(%r{http://localhost:3000/reports/(\d+)}).flatten.map(&:to_i).uniq

    already_mentioning_ids = mentioning_reports.map(&:id)
    new_mentioning_ids = mentioning_ids - already_mentioning_ids
    deleted_mentioning_ids = already_mentioning_ids - mentioning_ids

    new_mentioning_ids.each do |mentioning_id|
      mention = Mention.new(report_from: self, report_to: Report.find(mentioning_id))
      return false unless mention.save!
    end

    deleted_mentioning_ids.each do |deleted_mentioning_id|
      deleted_mention = Mention.find_by(report_from: self, report_to: Report.find(deleted_mentioning_id))
      return false unless deleted_mention.destroy!
    end

    true
  end
end
