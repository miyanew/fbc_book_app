# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  # 自分が他の日報に対して行った言及
  has_many :mentioning_report_mentions,
           class_name: 'ReportMention',
           foreign_key: 'mentioning_report_id',
           dependent: :destroy,
           inverse_of: :mentioning_report

  # 他の日報から受けた言及
  has_many :mentioned_report_mentions,
           class_name: 'ReportMention',
           foreign_key: 'mentioned_report_id',
           dependent: :destroy,
           inverse_of: :mentioned_report

  # 自分が言及している日報一覧
  has_many :mentioning_reports,
           through: :mentioned_report_mentions,
           source: :mentioning_report

  # 自分を言及している日報一覧
  has_many :mentioned_reports,
           through: :mentioning_report_mentions,
           source: :mentioned_report

  validates :title, presence: true
  validates :content, presence: true

  after_save :refresh_report_mentions

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  private

  def refresh_report_mentions
    mentioned_reports.destroy_all
    mentioned_report_ids = extract_mentioned_report_ids
    mentioned_report_ids.each do |mentioned_id|
      mentioning_report_mentions.create!(mentioned_report_id: mentioned_id)
    end
  end

  def extract_mentioned_report_ids
    detected_domain_ports = ['127.0.0.1:3000', 'localhost:3000']
    regex_patterns = detected_domain_ports.map { |domain_port| %r{http://#{domain_port}/reports/(\d+)} }
    extracted_ids = regex_patterns.flat_map { |pattern| content.scan(pattern) }
    mentioned_ids = extracted_ids.flatten.map(&:to_i).uniq
    Report.where(id: mentioned_ids).where.not(id:).pluck(:id)
  end
end
