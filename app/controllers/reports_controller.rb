# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
  end

  # GET /reports/new
  def new
    @report = current_user.reports.new
  end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)

    result = false
    Report.transaction do
      result = @report.save && update_mentions(@report)
    end

    if result
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    result = false
    Report.transaction do
      result = @report.update(report_params) && update_mentions(@report)
    end
    if result
      redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @report.destroy

    redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  def set_report
    @report = current_user.reports.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :content)
  end

  def scan_mentioning_ids(content)
    mentioning_ids = content.scan(%r{#{request.host}:#{request.port}/reports/(\d+)})

    mentioning_ids.flatten
  end

  def get_new_mentions(mentioning_ids, already_mentioning_ids)
    mentioning_ids.filter do |mentioning_id|
      !already_mentioning_ids.include?(mentioning_id)
    end
  end

  def get_deleted_mentions(mentioning_ids, already_mentioning_ids)
    already_mentioning_ids.filter do |already_mentioning_id|
      !mentioning_ids.include?(already_mentioning_id)
    end
  end

  def update_mentions(report)
    mentioning_ids = scan_mentioning_ids(report.content).map(&:to_i)

    mentioning_ids.uniq!
    already_mentioning_ids = report.mentioning_reports.map(&:id)
    new_mentioning_ids = get_new_mentions(mentioning_ids, already_mentioning_ids)
    deleted_mentioning_ids = get_deleted_mentions(mentioning_ids, already_mentioning_ids)

    new_mentioning_ids.each do |mentioning_id|
      mention = Mention.new(report_from: @report, report_to: Report.find(mentioning_id))
      return false unless mention.save
    end

    deleted_mentioning_ids.each do |deleted_mentioning_id|
      deleted_mention = Mention.find_by(report_from: report, report_to: Report.find(deleted_mentioning_id))
      return false unless deleted_mention.destroy
    end

    true
  end
end
