class OrganisationsController < ApplicationController
  before_action :set_organisation, only: [:show, :edit, :update, :destroy, :leave, :join]
  before_action :require_login
  
  def index
    @organisations = Organisation.all
  end

  def show
  end

  def new
    @organisation = Organisation.new
  end

  def create
    @organisation = Organisation.new(organisation_params)
    
    if @organisation.save
      redirect_to @organisation, notice: 'Organisation was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @organisation.update(organisation_params)
      redirect_to @organisation, notice: 'Organisation was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @organisation.destroy
    redirect_to organisations_path, notice: 'Organisation was successfully deleted.'
  end
  
  def leave
    # Delete all posts belonging to the current user in this organisation
    current_user.posts.destroy_all
    
    # Remove user from the organisation (set to nil)
    current_user.update(organisation_id: nil)
    
    redirect_to root_path, notice: 'You have successfully left the organisation. Your posts have been deleted.'
  end
  
  def join
    # Only allow users without an organisation to join
    if current_user.organisation.present?
      redirect_to organisations_path, alert: 'You must leave your current organisation before joining a new one.'
    else
      current_user.update(organisation: @organisation)
      redirect_to @organisation, notice: "You have successfully joined #{@organisation.name}."
    end
  end
  
  private
  
  def set_organisation
    @organisation = Organisation.find(params[:id])
  end
  
  def organisation_params
    params.require(:organisation).permit(:name, :country, :language)
  end
end
