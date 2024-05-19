class ReportsController < ApplicationController
  def index
    @reports = Report.order(:id).page(params[:page])
  end
end
