# frozen_string_literal: true

class Mention < ApplicationRecord
  belongs_to :report_from, class_name: 'Report'
  belongs_to :report_to, class_name: 'Report'
end
