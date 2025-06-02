# frozen_string_literal: true

class Mention < ApplicationRecord
  belongs_to :report_from, class_name: 'Report'
  belongs_to :report_to, class_name: 'Report'

  validates :report_from, uniqueness: { scope: :report_to }
end
