# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test '#editable?' do
    user = User.create(email: 'foo@example.com')
    report = Report.create(user: user)
    assert report.editable?(user)

    user2 = User.create(email: 'goo@example.com')
    assert_not report.editable?(user2)
  end

  test '#created_on' do
    report = Report.create(created_at: Time.new(2023, 10, 14, 12, 0, 0))
    assert_equal Date.new(2023, 10, 14), report.created_on
  end
end
