# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test 'correct_user_editable' do
    report = reports(:hoge_report)
    user = users(:alice)
    assert report.editable?(user)
  end

  test 'incorrect_user_unable_edit' do
    report = reports(:hoge_report)
    user = users(:two)
    assert_not report.editable?(user)
  end

  test 'created_on' do
    assert_equal(Date.new(2025, 5, 16), reports(:hoge_report).created_on)
  end

  test 'send_mentions' do
    report = reports(:hoge_report)
    assert_equal(report.mentioning_reports, [])

    report.content = 'http://localhost:3000/reports/1'

    report.send(:save_mentions)
    assert_equal(report.mentioning_reports, [Report.find(1)])

    report.content = 'http://localhost:3000/reports/1\nhttp://localhost:3000/reports/1\nhttp://localhost:3000/reports/2'
    report.send(:save_mentions)
    assert_equal(report.mentioning_reports, [Report.find(1), Report.find(2)])
  end
end
