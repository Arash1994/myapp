class PostsController < ApplicationController
  # before_action :check_required_params
  
  def new
  	@post = Post.new
  end

  def index
  	@posts = Post.all
  end

  def show
  	@post = Post.find_by_id(params[:id])
  end

  def create
    # check_required_params params, [:title, :description, :category_id]
  	@post = Post.create(permit_params)
  	if @post.save
  		flash[:success] ="Success!"
  		redirect_to post_path(@post)
  	else
     	flash[:error] =@post.errors.full_messages
  		redirect_to new_post_path(@post)
  	end
  	
  end
  def destroy
    @post = Post.find_by_id(params[:id])
    @post.destroy
    flash[:success] ="Category was successfully destroyed."
    redirect_to posts_url
  end

  private

  	def permit_params
  		params.require(:post).permit(:title, :description, :category_id, :image)
  	end

end

