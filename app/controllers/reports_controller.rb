class ReportsController < ApplicationController
  def index
    @reports = Report.order(:id).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
  end
end
