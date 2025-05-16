class Api::V1::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }
  before_action :set_user, only: [:show]

  # GET /api/v1/users
  def index
    @users = User.active
    
    render json: @users.map { |user| format_user(user) }
  end

  # GET /api/v1/users/:id
  def show
    render json: format_user(@user)
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end

  def format_user(user)
    {
      id: user.id,
      name: user.name,
      email: user.email,
      organisation_id: user.organisation_id,
      organisation_name: user.organisation&.name
    }
  end
end
