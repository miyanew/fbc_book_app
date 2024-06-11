# frozen_string_literal: true

class ReportsController < ApplicationController
  include CommentableConcerns
  before_action :set_commentable, only: %i[show edit update destroy]
  before_action :correct_user, only: %i[edit update]

  def index
    @reports = Report.order(:id).page(params[:page])
  end

  def show; end

  def new
    @commentable = Report.new
  end

  def edit; end

  def create
    @commentable = current_user.reports.build(report_params)

    if @commentable.save
      redirect_to @commentable
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    respond_to do |format|
      if @commentable.update(report_params)
        format.html { redirect_to report_url(@commentable), notice: t('controllers.common.notice_update', name: Report.model_name.human) }
        format.json { render :show, status: :ok, location: @commentable }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @commentable.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @commentable.destroy

    respond_to do |format|
      format.html { redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human) }
      format.json { head :no_content }
    end
  end

  private

  def report_params
    params.require(:report).permit(:title, :body)
  end

  def correct_user
    @commentable = current_user.reports.find_by(id: params[:id])
    redirect_to reports_path, notice: I18n.t('errors.messages.no_permission') if @commentable.nil?
  end
end
