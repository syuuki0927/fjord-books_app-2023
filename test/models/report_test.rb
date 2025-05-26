# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @report_by_alice = reports(:report_by_alice)
    @report = reports(:report_by_alice)
  end

  test 'correct_user_editable' do
    alice = users(:alice)
    assert @report_by_alice.editable?(alice)
  end

  test 'incorrect_user_unable_edit' do
    bob = users(:bob)
    assert_not @report_by_alice.editable?(bob)
  end

  test 'created_on' do
    assert_equal(Date.new(2025, 5, 16), @report.created_on)
  end

  test 'save_mentions' do
    assert_equal([], @report.mentioning_reports)

    @report.content = 'http://localhost:3000/reports/1'

    @report.save
    assert_equal([Report.find(1)], @report.mentioning_reports)

    @report.content = <<-TEXT
    http://localhost:3000/reports/1
    http://localhost:3000/reports/1
    http://localhost:3000/reports/2
    TEXT

    @report.save
    assert_equal([Report.find(1), Report.find(2)], @report.mentioning_reports)
  end
end
