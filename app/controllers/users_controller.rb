# frozen_string_literal: true

class UsersController < ApplicationController

  # GET /resource
  def index
    @users = User.order(:id).page(params[:page])
  end

  # GET /resource
  def show
    @user = User.find(params[:id])
  end
end
