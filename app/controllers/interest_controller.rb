class InterestController < ApplicationController
   before_action :find_user

  def new
  	@interest = Intrest.new
  end

  def index
  	@interest = @user.categories
  end

  def show
  	@interest = Intrest.find_by_id(params[:id])
  end

  def create
    # check_required_params params, [:title, :description, :category_id]
  	@interest = Intrest.create(permit_params)
  	if @interest.save
  		flash[:success] ="Success!"
  		redirect_to post_path(@interest)
  	else
     	flash[:error] =@post.errors.full_messages
  		redirect_to new_post_path(@interest)
  	end

  end
  def destroy
    @interest = Intrest .find_by_id(params[:id])
    @interest.destroy
    flash[:success] ="Category was successfully destroyed."
    redirect_to posts_url
  end

  private
    def find_user
      @user=User.find_by_id(current_user.id)
      #code
    end
  	def permit_params
  		params.require(interest_id:[ , :])
  	end

end
