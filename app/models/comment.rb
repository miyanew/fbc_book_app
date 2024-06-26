# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true
  validates :commentable_type, presence: true
  validates :commentable_id, presence: true
  validates :user_id, presence: true
end
