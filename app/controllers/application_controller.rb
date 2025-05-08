# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  private

  def after_sign_out_path_for(_)
    new_user_session_path
  end

  def after_sign_in_path_for(resource)
    user_path(resource)
  end
end
