# frozen_string_literal: true

require 'application_system_test_case'

class BooksTest < ApplicationSystemTestCase
  setup do
    @book = books(:cherry)
    @alice = users(:alice)

    visit root_url
    fill_in 'Eメール', with: @alice.email
    fill_in 'パスワード', with: 'anzenpas_ruby_plactice2323'
    click_button 'ログイン'
    assert_text 'ログインしました。', wait: 5
  end

  test 'visiting the index' do
    visit books_url

    assert_selector 'h1', text: '本の一覧'
  end

  test 'should create book' do
    new_title = '新しいタイトル'
    new_memo = '新しいメモ'
    visit books_url
    click_on '本の新規作成'
    assert_nil Book.find_by(title: new_title, memo: new_memo)

    fill_form(new_title, new_memo, '登録する')

    assert_text '本が作成されました。'
    assert_not_nil Book.find_by(title: new_title, memo: new_memo)
    click_on '本の一覧に戻る'
  end

  test 'should update Book' do
    editted_title = '編集後のタイトル'
    editted_memo = '編集後のメモ'

    visit book_url(@book)
    click_on 'この本を編集', match: :first
    assert_nil Book.find_by(title: editted_title, memo: editted_memo)

    fill_form(editted_title, editted_memo, '更新')

    assert_text '本が更新されました。'
    assert_not_nil Book.find_by(title: editted_title, memo: editted_memo)
    click_on '本の一覧に戻る'
  end

  test 'should destroy Book' do
    visit book_url(@book)
    click_on 'この本を削除', match: :first
    assert_not_nil Book.find(@book.id)

    assert_text '本が削除されました。'
    assert_raises(ActiveRecord::RecordNotFound) do
      Book.find(@book.id)
    end
  end

  def fill_form(title, memo, button)
    fill_in 'タイトル', with: title
    fill_in 'メモ', with: memo
    click_on button
  end
end
