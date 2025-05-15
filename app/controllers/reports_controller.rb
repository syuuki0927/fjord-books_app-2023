# frozen_string_literal: true

class ReportsController < ApplicationController
  # GET /reports or /reports.json
  def index
    @reports = Report.all
  end

  # GET /reports/1 or /reports/1.json
  def show
    @report = Report.find(params[:id])
  end

  # GET /reports/new
  def new
    @report = Report.new
  end

  # GET /reports/1/edit
  def edit
    @report = Report.find(params[:id])

    redirect_to report_url(@report) if @report.user != current_user
  end

  # POST /reports or /reports.json
  def create
    @report = Report.new(report_params.merge(user_id: current_user.id))

    if @report.save
      redirect_to report_url(@report), notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reports/1 or /reports/1.json
  def update
    @report = Report.find(params[:id])
    if @report.user == current_user && @report.update(report_params)
      redirect_to report_url(@report), notice: t('controllers.common.notice_update', name: Report.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /reports/1 or /reports/1.json
  def destroy
    @report = Report.find(params[:id])

    if @report.user == current_user && @report.destroy
      redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
    else
      redirect_to report_url(@report), notice: t('controllers.common.notice_unable_destroy', name: Report.model_name.human)
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def report_params
    params.require(:report).permit(:title, :content)
  end
end
