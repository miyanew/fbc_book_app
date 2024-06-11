# frozen_string_literal: true

module CommentableConcerns
  extend ActiveSupport::Concern

  private

  def set_commentable
    @commentable = commentable_class.includes(comments: :user).find(params[:id])
  end

  def commentable_class
    controller_name.classify.constantize
  end
end
