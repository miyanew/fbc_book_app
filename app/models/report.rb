# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :mentioning_report_mentions, class_name: 'ReportMention', foreign_key: 'mentioning_report_id', dependent: :destroy
  has_many :mentioned_report_mentions, class_name: 'ReportMention', foreign_key: 'mentioned_report_id', dependent: :destroy

  has_many :mentioning_reports, through: :mentioned_report_mentions, source: :mentioning_report
  has_many :mentioned_reports, through: :mentioning_report_mentions, source: :mentioned_report

  validates :title, presence: true
  validates :content, presence: true

  after_create :create_report_mentions
  before_destroy :destroy_related_report_mentions
  after_update :update_report_mentions

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  private

  def create_report_mentions
    mentioning_report_ids = extract_mentioning_report_ids
    mentioning_report_ids.each do | mentioning_id|
      ReportMention.create(
        mentioning_report_id: mentioning_id,
        mentioned_report_id: self.id
      )
    end
  end

  def extract_mentioning_report_ids
    detected_domain_ports = ["127.0.0.1:3000", "localhost:3000"]
    regex_patterns = detected_domain_ports.map {|domain_port| /http:\/\/#{domain_port}\/reports\/(\d+)/}
    extracted_ids = regex_patterns.flat_map {|pattern|content.scan(pattern)}
    mentioning_ids = extracted_ids.flatten.map(&:to_i).uniq - [id]
    Report.where(id: mentioning_ids).pluck(:id)
  end

  def destroy_related_report_mentions
    ReportMention.where(mentioning_report_id: id).or(ReportMention.where(mentioned_report_id: id)).destroy_all
  end

  def update_report_mentions
    ReportMention.where(mentioned_report_id: id).destroy_all
    create_report_mentions
  end
end
