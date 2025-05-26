# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @report = reports(:report_by_alice)
  end

  test 'correct_user_editable' do
    user = users(:alice)
    assert @report.editable?(user)
  end

  test 'incorrect_user_unable_edit' do
    user = users(:bob)
    assert_not @report.editable?(user)
  end

  test 'created_on' do
    assert_equal(Date.new(2025, 5, 16), @report.created_on)
  end

  test 'save_mentions' do
    assert_equal(@report.mentioning_reports, [])

    @report.content = 'http://localhost:3000/reports/1'

    @report.save
    assert_equal(@report.mentioning_reports, [Report.find(1)])

    @report.content = <<-TEXT
    http://localhost:3000/reports/1
    http://localhost:3000/reports/1
    http://localhost:3000/reports/2
    TEXT

    @report.save
    assert_equal(@report.mentioning_reports, [Report.find(1), Report.find(2)])
  end
end
