class CommentsController < ApplicationController
  before_action :set_report

  def create
    @comment = @report.comments.create(comment_params)
    redirect_to report_path(@report)
  end
  
  private
    def comment_params
      params.require(:comment).permit(:body)
    end

    def set_report
      @report = Report.find(params[:report_id])
    end
end
