# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @report = reports(:hoge_report)
    @alice = users(:alice)

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

    fill_in '内容', with: @report.content
    fill_in 'タイトル', with: @report.title
    click_on '登録する'

    assert_text '日報が作成されました'
    click_on '戻る'
  end

  test 'should update Report' do
    visit report_url(@report)
    click_on '日報を編集', match: :first

    fill_in '内容', with: @report.content
    fill_in 'タイトル', with: @report.title
    click_on '更新'

    assert_text '日報が更新されました'
    click_on '戻る'
  end

  test 'should destroy Report' do
    visit report_url(@report)
    click_on 'この日報を削除', match: :first

    assert_text '日報が削除されました。'
  end
end
