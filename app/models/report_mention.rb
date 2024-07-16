class ReportMention < ApplicationRecord
  belongs_to :mentioning_report
  belongs_to :mentioned_report
end
