# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test 'should be editable by the creator' do
    alice = users(:alice)
    alice_report = alice.reports.create!(title: 'title', content: 'content')
    assert alice_report.editable?(alice)
  end

  test 'should not be editable when the user is not the creator' do
    alice_report = reports(:alice_report)
    bob = users(:bob)
    assert_not alice_report.editable?(bob)
  end

  test 'should return the date when the report was created' do
    report = Report.create(created_at: Time.zone.local(2023, 10, 14, 12, 0, 0))
    assert_equal Date.new(2023, 10, 14), report.created_on
  end
end
