# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test 'should be editable by the creator' do
    user = User.create(email: 'foo@example.com')
    report = Report.create(user:)
    assert report.editable?(user)
  end

  test 'should not be editable when the user is not the creator' do
    creator = User.create(email: 'foo@example.com')
    other_user = User.create(email: 'goo@example.com')
    report = Report.create(user: creator)
    assert_not report.editable?(other_user)
  end

  test 'should return the date when the report was created' do
    report = Report.create(created_at: Time.zone.local(2023, 10, 14, 12, 0, 0))
    assert_equal Date.new(2023, 10, 14), report.created_on
  end
end
