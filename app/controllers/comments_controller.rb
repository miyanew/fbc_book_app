class CommentsController < ApplicationController
  before_action :set_commentable, only: [:create, :destroy]

  def create
    @comment = @commentable.comments.create(comment_params)
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
      resource, id = request.path.split('/')[1,2]

      case resource
      when 'reports'
        @commentable = Report.find(id)
      when 'books'
        @commentable = Book.find(id)
      end
    end
  end
