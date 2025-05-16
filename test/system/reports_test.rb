# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @report = reports(:report)
    @alice = users(:alice)

    @new_title = '新しい日報'
    @new_content = '新しい内容'

    visit root_url
    fill_in 'Eメール', with: @alice.email
    fill_in 'パスワード', with: 'anzenpas_ruby_plactice2323'
    click_button 'ログイン'
    assert_text 'ログインしました。', wait: 5
  end

  test 'visiting the index' do
    visit reports_url
    assert_selector 'h1', text: '日報'
  end

  test 'should create report' do
    visit reports_url
    click_on '日報の新規作成'

    assert_no_text @new_title
    assert_no_text @new_content

    assert_nil Report.find_by(title: @new_title)

    fill_form(@new_title, @new_content, '登録する')

    assert_text '日報が作成されました'
    click_on '戻る'
    new_report = Report.find_by(title: @new_title)
    assert_equal @new_title, new_report.title
    assert_equal @new_content, new_report.content
    assert_text @new_title
    assert_text @new_content
  end

  test 'should update Report' do
    new_report = Report.find_by(title: @new_title)
    assert_not_equal @new_title, new_report
    assert_not_equal @new_content, new_report
    assert_no_text @new_title
    assert_no_text @new_content

    visit report_url(@report)
    click_on '日報を編集', match: :first

    fill_form(@new_title, @new_content, '更新')

    assert_text '日報が更新されました'
    visit report_url(@report)
    new_report = Report.find_by(title: @new_title)
    assert_equal @new_title, new_report.title
    assert_equal @new_content, new_report.content
    assert_text @new_title
    assert_text @new_content
  end

  test 'should destroy Report' do
    visit reports_url
    assert_text @report.title
    assert_text @report.content
    visit report_url(@report)
    assert_equal @report, Report.find(@report.id)

    click_on 'この日報を削除', match: :first

    assert_text '日報が削除されました。'
    assert_raises(ActiveRecord::RecordNotFound) do
      Report.find(@report.id)
    end
    assert_no_text @report.title
    assert_no_text @report.content
  end

  test 'should save mentions when Report created' do
    @new_content = 'http://localhost:3000/reports/1とhttp://localhost:3000/reports/2が参考になると思います。'

    report1 = Report.find(1)
    report2 = Report.find(2)

    visit report_url(report1)
    assert_no_text @new_title
    visit report_url(report2)
    assert_no_text @new_title

    visit reports_url
    click_on '日報の新規作成'

    fill_form(@new_title, @new_content, '登録する')

    assert_text '日報が作成されました'
    click_on '戻る'
    new_report = Report.find_by(title: @new_title)
    assert_equal [report1, report2], new_report.mentioning_reports

    visit report_url(report1)
    assert_text @new_title
    visit report_url(report2)
    assert_text @new_title
  end

  test 'should add/delete mention when Report updated' do
    report1 = Report.find(1)
    report2 = Report.find(2)

    @new_content = 'http://localhost:3000/reports/1とhttp://localhost:3000/reports/2が参考になると思います。'

    # before update
    visit report_url(report1)
    assert_no_text @new_title
    visit report_url(report2)
    assert_no_text @new_title
    visit report_url(@report)

    click_on '日報を編集', match: :first
    fill_form(@new_title, @new_content, '更新')

    # after add mention update
    visit report_url(report1)
    assert_text @new_title
    visit report_url(report2)
    assert_text @new_title

    @new_content = 'http://localhost:3000/reports/2が参考になると思います。'
    visit report_url(@report)
    click_on '日報を編集', match: :first
    fill_form(@new_title, @new_content, '更新')

    # after delete mention update
    visit report_url(report1)
    assert_no_text @new_title
    visit report_url(report2)
    assert_text @new_title
  end

  test 'should delete mention when Report deleted' do
    @new_content = 'http://localhost:3000/reports/1が参考になると思います。'

    report1 = Report.find(1)

    visit report_url(report1)
    assert_no_text @new_title

    visit reports_url
    click_on '日報の新規作成'

    fill_form(@new_title, @new_content, '登録する')

    assert_text '日報が作成されました'
    click_on '戻る'
    new_report = Report.find_by(title: @new_title)
    assert_equal [report1], new_report.mentioning_reports

    visit report_url(report1)
    assert_text @new_title

    visit report_url(new_report)
    click_on 'この日報を削除', match: :first
    visit report_url(report1)
    assert_no_text @new_title
  end

  def fill_form(title, content, button)
    fill_in 'タイトル', with: title
    fill_in '内容', with: content
    click_on button
  end
end
