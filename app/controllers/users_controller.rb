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
    
    # Set user_update_params without current_password
    user_update_params = params.require(:user).permit(:name, :email, :password, :password_confirmation, :organisation_id)
    
    # If password is blank, don't update it
    if user_update_params[:password].blank?
      user_update_params = user_update_params.except(:password, :password_confirmation)
    end
    
    if @user.update(user_update_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: 'User was successfully deleted.'
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
