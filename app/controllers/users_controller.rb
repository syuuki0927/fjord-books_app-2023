# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show]
  def index
    @users = User.order(:emal).page(params[:page])
  end

  def show; end

  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:email, :postal_code, :address, :bio)
  end
end
