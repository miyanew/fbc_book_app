# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_commentable, only: %i[create destroy]
  before_action :correct_user, only: %i[destroy]

  def create
    @comment = current_user.comments.build(comment_params)
    @comment.commentable = @commentable

    return unless @comment.save

    redirect_to polymorphic_url(@commentable)
  end

  def destroy
    @comment = @commentable.comments.find(params[:id])
    @comment.destroy
    redirect_to polymorphic_url(@commentable)
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_commentable
    resource, id = request.path.split('/')[1, 2]
    case resource
    when 'reports'
      @commentable = Report.find(id)
    when 'books'
      @commentable = Book.find(id)
    end
  end

  def correct_user
    @comment = current_user.comments.find_by(id: params[:id])
    redirect_to polymorphic_url(@commentable), notice: I18n.t('errors.messages.no_permission') if @comment.nil?
  end
end
