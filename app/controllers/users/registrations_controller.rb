# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # GET /resource
  def index
    redirect_to new_user_session_path if user_session.nil?
    @users = User.order(:id).page(params[:page])
  end

  # GET /resource
  def show
    redirect_to new_user_session_path if user_session.nil?
    @user = User.find(params[:id])
  end

  protected

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    super(resource)
    books_path
  end

  def after_update_path_for(resource)
    user_profile_path(resource)
  end
end
