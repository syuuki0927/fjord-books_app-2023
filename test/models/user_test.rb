# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'test_name_or_email' do
    user = users(:alice)
    assert_equal('alice', user.name_or_email)

    user.name = nil
    assert_equal('alice@example.com', user.name_or_email)
  end
end
