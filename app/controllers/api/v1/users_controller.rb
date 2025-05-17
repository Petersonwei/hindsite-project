class Api::V1::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }
  before_action :set_user, only: [:show, :organisations]

  # GET /api/v1/users
  def index
    @users = User.active
    
    render json: @users.map { |user| format_user(user) }
  end

  # GET /api/v1/users/:id
  def show
    render json: format_user(@user)
  end
  
  # GET /api/v1/users/:id/organisations
  def organisations
    render json: {
      organisations: @user.organisations.map do |org|
        {
          id: org.id,
          name: org.name,
          country: org.country,
          language: org.language,
          is_primary: (@user.primary_organisation == org)
        }
      end,
      primary_organisation_id: @user.primary_organisation&.id
    }
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
      # Keep old fields for backward compatibility
      organisation_id: user.organisation_id,
      organisation_name: user.organisation&.name,
      # Add new multi-organization fields
      organisations: user.organisations.map do |org|
        {
          id: org.id,
          name: org.name,
          is_primary: (user.primary_organisation == org)
        }
      end,
      primary_organisation: {
        id: user.primary_organisation&.id,
        name: user.primary_organisation&.name
      }
    }
  end
end
