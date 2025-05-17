class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :require_login
  
  def index
    # Get user's organizations
    @user_organisations = current_user.organisations
    
    # Get the selected organization (default to primary if not specified)
    if params[:organisation_id].present?
      @organisation = Organisation.find(params[:organisation_id])
    else
      @organisation = current_user.primary_organisation
    end
    
    if @organisation.present? && current_user.organisations.include?(@organisation)
      # Start with the base query for posts from this organisation
      @posts = Post.where(organisation_id: @organisation.id)
      
      # Filter by user (employee) if specified
      if params[:user_id].present? && !params[:user_id].empty?
        @posts = @posts.where(user_id: params[:user_id])
      end
      
      # Filter by date range if specified
      if params[:start_date].present? && !params[:start_date].empty?
        @posts = @posts.where('posts.created_at >= ?', params[:start_date])
      end
      
      if params[:end_date].present? && !params[:end_date].empty?
        @posts = @posts.where('posts.created_at <= ?', params[:end_date].to_date.end_of_day)
      end
      
      # Get users for the filter dropdown (members of this org)
      @users = @organisation.members.where(status: 'active').order(:name)
      
      # Apply final ordering
      @posts = @posts.order(created_at: :desc)
    else
      # If user has no organisations, show only their posts
      @posts = current_user.posts.order(created_at: :desc)
      @no_organisation = true
    end
  end
  
  def departed_posts
    # Get user's organizations
    @user_organisations = current_user.organisations
    
    # Get the selected organization (default to primary if not specified)
    if params[:organisation_id].present?
      @organisation = Organisation.find(params[:organisation_id])
    else
      @organisation = current_user.primary_organisation
    end
    
    if @organisation.present? && current_user.organisations.include?(@organisation)
      # Get departed users in this organisation
      departed_users = User.joins(:user_organisations)
                          .where(user_organisations: { organisation_id: @organisation.id })
                          .where(status: 'departed')
      
      # Get their posts in this organization
      @departed_posts = Post.where(user_id: departed_users.pluck(:id), organisation_id: @organisation.id)
      
      # Filter by user (employee) if specified
      if params[:user_id].present? && !params[:user_id].empty?
        @departed_posts = @departed_posts.where(user_id: params[:user_id])
      end
      
      # Filter by date range if specified
      if params[:start_date].present? && !params[:start_date].empty?
        @departed_posts = @departed_posts.where('posts.created_at >= ?', params[:start_date])
      end
      
      if params[:end_date].present? && !params[:end_date].empty?
        @departed_posts = @departed_posts.where('posts.created_at <= ?', params[:end_date].to_date.end_of_day)
      end
      
      # Get departed users for the filter dropdown
      @departed_users = departed_users.order(:name)
      
      # Apply final ordering
      @departed_posts = @departed_posts.order(created_at: :desc)
    else
      @departed_posts = []
      @no_organisation = true
    end
  end

  def show
  end

  def new
    @post = Post.new
    @user_organisations = current_user.organisations
  end

  def create
    @post = current_user.posts.new(post_params)
    
    # Ensure the user belongs to the selected organisation
    unless current_user.organisations.pluck(:id).include?(@post.organisation_id.to_i)
      @user_organisations = current_user.organisations
      flash.now[:alert] = "You can only post to organisations you are a member of"
      return render :new, status: :unprocessable_entity
    end
    
    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      @user_organisations = current_user.organisations
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize_user
    @user_organisations = current_user.organisations
  end

  def update
    if @post.user != current_user
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to posts_path and return
    end
    
    # Ensure the user belongs to the selected organisation
    unless current_user.organisations.pluck(:id).include?(post_params[:organisation_id].to_i)
      @user_organisations = current_user.organisations
      flash.now[:alert] = "You can only post to organisations you are a member of"
      return render :edit, status: :unprocessable_entity
    end
    
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      @user_organisations = current_user.organisations
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @post.user != current_user
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to posts_path and return
    end
    
    @post.destroy
    redirect_to posts_path, notice: 'Post was successfully deleted.'
  end
  
  private
  
  def set_post
    @post = Post.find(params[:id])
  end
  
  def post_params
    params.require(:post).permit(:description, :organisation_id)
  end
  
  def authorize_user
    unless @post.user == current_user
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to posts_path and return false
    end
    true
  end
end
