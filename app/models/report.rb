# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :mentioning, class_name: 'Mention', foreign_key: 'report_from_id', dependent: :destroy, inverse_of: :report_from
  has_many :mentioning_reports, through: :mentioning, source: :report_to

  has_many :mentioned, class_name: 'Mention', foreign_key: 'report_to_id', dependent: :destroy, inverse_of: :report_to
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
    transaction do
      save!
      update_mentions!

      true
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  def update_with_mentions(params)
    transaction do
      update!(params)
      update_mentions!

      true
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def update_mentions!
    mentioning_ids = content.scan(%r{http://localhost:3000/reports/(\d+)}).flatten.map(&:to_i).uniq

    already_mentioning_ids = mentioning_reports.map(&:id)
    new_mentioning_ids = mentioning_ids - already_mentioning_ids
    deleted_mentioning_ids = already_mentioning_ids - mentioning_ids

    new_mentioning_ids.each do |mentioning_id|
      new_mentioning_report = Report.find_by(id: mentioning_id)
      mentioning_reports << new_mentioning_report unless new_mentioning_report.nil?
    end

    deleted_mentioning_ids.each do |deleted_mentioning_id|
      mentioning.find_by(report_to_id: deleted_mentioning_id).destroy!
    end

    true
  end
end
