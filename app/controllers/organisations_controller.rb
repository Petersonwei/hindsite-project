class OrganisationsController < ApplicationController
  before_action :set_organisation, only: [:show, :edit, :update, :destroy, :leave, :join, :set_primary]
  before_action :require_login
  
  def index
    @organisations = Organisation.all
    @user_organisations = current_user.organisations
  end

  def show
    @is_member = current_user.organisations.include?(@organisation)
    @is_primary = current_user.primary_organisation == @organisation
  end

  def new
    @organisation = Organisation.new
  end

  def create
    @organisation = Organisation.new(organisation_params)
    
    if @organisation.save
      # Automatically join the creator to the organization as primary if they have no primary
      if !current_user.primary_organisation
        join_and_set_primary
      else
        redirect_to @organisation, notice: 'Organisation was successfully created.'
      end
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
  
  def join
    # Check if already a member
    return redirect_to @organisation, notice: 'You are already a member of this organisation.' if current_user.organisations.include?(@organisation)
    
    # Create the membership
    user_org = current_user.user_organisations.build(organisation: @organisation)
    
    # If this is the user's first organization, make it primary
    user_org.is_primary = true if current_user.organisations.empty?
    
    if user_org.save
      redirect_to @organisation, notice: "You have successfully joined #{@organisation.name}."
    else
      redirect_to organisations_path, alert: "Unable to join organisation."
    end
  end
  
  def leave
    user_org = current_user.user_organisations.find_by(organisation: @organisation)
    
    if user_org
      was_primary = user_org.is_primary?
      
      # Remove all posts for this organization
      current_user.posts.where(organisation: @organisation).destroy_all
      
      # Remove the association
      user_org.destroy
      
      # If this was the primary, set a new primary if possible
      if was_primary && current_user.organisations.any?
        current_user.primary_organisation = current_user.organisations.first
      end
      
      redirect_to organisations_path, notice: "You have successfully left #{@organisation.name}."
    else
      redirect_to organisations_path, alert: "You are not a member of this organisation."
    end
  end
  
  def set_primary
    # Check if a member first
    unless current_user.organisations.include?(@organisation)
      return redirect_to organisations_path, alert: "You must be a member of this organisation to set it as primary."
    end
    
    current_user.primary_organisation = @organisation
    redirect_to @organisation, notice: "#{@organisation.name} is now your primary organisation."
  end
  
  private
  
  def set_organisation
    @organisation = Organisation.find(params[:id])
  end
  
  def organisation_params
    params.require(:organisation).permit(:name, :country, :language)
  end
  
  def join_and_set_primary
    user_org = current_user.user_organisations.create(organisation: @organisation, is_primary: true)
    redirect_to @organisation, notice: 'Organisation was successfully created and set as your primary organisation.'
  end
end
