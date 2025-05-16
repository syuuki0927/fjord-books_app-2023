# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  #
  test 'test_name_or_email' do
    user = users(:alice)

    assert_equal(user.name_or_email, 'alice')

    user.name = nil

    assert_equal(user.name_or_email, 'alice@example.com')
  end
end
