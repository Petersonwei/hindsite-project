class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_login, except: [:new, :create]
  
  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      # Create user_organisation record if organisation_id is present
      if params[:user][:organisation_id].present?
        organisation = Organisation.find_by(id: params[:user][:organisation_id])
        if organisation
          @user.user_organisations.create(organisation: organisation, is_primary: true)
        end
      end
      
      session[:user_id] = @user.id
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    # Check if attempting to change password
    if password_change_attempted?
      # Verify current password
      unless @user.authenticate(params[:user][:current_password])
        @user.errors.add(:current_password, "is incorrect")
        return render :edit, status: :unprocessable_entity
      end
    end
    
    # Set user_update_params without current_password and remove organisation_id for separate handling
    user_update_params = params.require(:user).permit(:name, :email, :password, :password_confirmation)
    
    # If password is blank, don't update it
    if user_update_params[:password].blank?
      user_update_params = user_update_params.except(:password, :password_confirmation)
    end
    
    # Handle organisation changes separately from basic user fields
    organisation_updated = false
    if params[:user][:organisation_id].present?
      organisation = Organisation.find_by(id: params[:user][:organisation_id])
      if organisation && !@user.organisations.include?(organisation)
        @user.user_organisations.create(organisation: organisation, is_primary: true)
        organisation_updated = true
      end
    end
    
    if @user.update(user_update_params) || organisation_updated
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: 'User was successfully deleted.'
  end
  
  def depart
    @user = User.find(params[:id])
    if @user.depart!
      redirect_to users_path, notice: "User was marked as departed. Their posts are now available in the departed posts section."
    else
      redirect_to users_path, alert: "Failed to mark user as departed."
    end
  end
  
  def reactivate
    @user = User.find(params[:id])
    if @user.reactivate!
      redirect_to users_path, notice: "User was reactivated. Their posts are now visible in the main feed."
    else
      redirect_to departed_posts_path, alert: "Failed to reactivate user."
    end
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :organisation_id)
  end
  
  def password_change_attempted?
    params[:user] && params[:user][:password].present?
  end
end
