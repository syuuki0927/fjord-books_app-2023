# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = User.with_attached_avator.order(:id).page(params[:page])
  end

  def show
    @user = User.find(params[:id])
  end
end
