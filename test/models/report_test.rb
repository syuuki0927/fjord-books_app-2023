# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  def correct_user_editable
    report = Report.find_by(user: 'one')
    user = User.find_by(name: 'one')
    assert(report.editable?(user))
  end
  # test "the truth" do
  #   assert true
  # end
end
