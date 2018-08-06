class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :destroy]
  before_action :is_admin, only: [:new, :ceate, :edit, :update, :destroy]
  after_action :is_admin, only: [:new, :ceate, :edit, :update, :destroy]

  helper PostsHelper

  def index
    if params[:tag]
      @posts = Post.tagged_with(params[:tag]).order("created_at DESC")
    else
      @posts = Post.page(params[:page]).per(4).order("created_at DESC")
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:notice] = "Post created."
      redirect_to @post
    else
      flash[:alert] = "There is some errors."
      render 'create'
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = "Post updated."
      redirect_to @post
    else
      flash[:alert] = "There is some errors."
      render 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "Post deleted."
    redirect_to root_path
  end


  private

  def post_params
    params.require(:post).permit(:title, :body, :tag_list, :image, :user)
  end

  def is_admin
    unless current_user.admin?
      flash[:alert] = "You have no permissions to do that."
      redirect_to root_path
    end
  end

  def is_owner
    unless @post.user == current_user.try
      flash[:alert] = "That post does not belongs to you."
      redirect_to @post
    end
  end

end



