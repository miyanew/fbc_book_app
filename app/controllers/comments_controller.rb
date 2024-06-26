# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_commentable, only: %i[create destroy]

  def create
    @comment = current_user.comments.build(comment_params)
    @comment.commentable = @commentable
    @comment.save!
    redirect_to @commentable
  end

  def destroy
    @comment = @commentable.comments.find(params[:id])
    return unless current_user == @comment.user

    @comment.destroy
    redirect_to @commentable
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
