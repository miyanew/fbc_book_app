# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :avatar
  validate :avatar_type

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [128, 128]
  end

  def avatar_type
    return unless avatar.attached? && !avatar.content_type.in?(%('image/jpeg image/png image/gif'))

    errors.add(:avatar, :invalid_type)
  end
end
