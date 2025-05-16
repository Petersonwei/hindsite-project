class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :require_login
  
  def index
    if current_user.organisation.present?
      # Get posts from users in the same organisation
      @posts = Post.joins(:user)
                   .where(users: { organisation_id: current_user.organisation_id, status: 'active' })
                   .order(created_at: :desc)
    else
      # If user has no organisation, show only their posts
      @posts = current_user.posts.order(created_at: :desc)
      @no_organisation = true
    end
  end
  
  def departed_posts
    if current_user.organisation.present?
      # Get posts from departed users in the same organisation
      @departed_posts = Post.joins(:user)
                           .where(users: { organisation_id: current_user.organisation_id, status: 'departed' })
                           .order(created_at: :desc)
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
    authorize_user
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize_user
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
      redirect_to posts_path
    end
  end
end
