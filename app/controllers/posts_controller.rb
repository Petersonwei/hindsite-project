class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :require_login
  
  def index
    if current_user.organisation.present?
      # Start with the base query for posts from users in the same organisation
      @posts = Post.joins(:user)
                   .where(users: { organisation_id: current_user.organisation_id, status: 'active' })
      
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
      
      # Get users for the filter dropdown
      @users = User.where(organisation_id: current_user.organisation_id, status: 'active')
                  .order(:name)
      
      # Apply final ordering
      @posts = @posts.order(created_at: :desc)
    else
      # If user has no organisation, show only their posts
      @posts = current_user.posts.order(created_at: :desc)
      @no_organisation = true
    end
  end
  
  def departed_posts
    if current_user.organisation.present?
      # Start with base query for departed users in the same organisation
      @departed_posts = Post.joins(:user)
                          .where(users: { organisation_id: current_user.organisation_id, status: 'departed' })
      
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
      @departed_users = User.where(organisation_id: current_user.organisation_id, status: 'departed')
                          .order(:name)
      
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
  end

  def create
    @post = current_user.posts.new(post_params)
    
    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize_user
  end

  def update
    if @post.user != current_user
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to posts_path and return
    end
    
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
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
    params.require(:post).permit(:description)
  end
  
  def authorize_user
    unless @post.user == current_user
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to posts_path and return false
    end
    true
  end
end
