# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[show edit update destroy]
  before_action :correct_user, only: %i[edit update]

  def index
    @reports = Report.order(:id).page(params[:page])
  end

  def show
    @commentable = Report.find(params[:id])
  end

  def new
    @report = Report.new
  end

  def create
    @report = current_user.reports.build(report_params)

    if @report.save
      redirect_to @report
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to report_url(@report), notice: t('controllers.common.notice_update', name: Report.model_name.human) }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @report.destroy

    respond_to do |format|
      format.html { redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human) }
      format.json { head :no_content }
    end
  end

  private

  def set_report
    @report = Report.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :body)
  end

  def correct_user
    @report = current_user.reports.find_by(id: params[:id])
    redirect_to reports_path, notice: I18n.t('errors.messages.no_permission') if @report.nil?
  end
end
