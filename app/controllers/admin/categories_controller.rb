class Admin::CategoriesController < ApplicationController
  before_action :set_admin_category, only: [:show, :edit, :update, :destroy]

  # GET /admin/categories
  # GET /admin/categories.json
  def index
    @categories = Category.all
  end

  # GET /admin/categories/1
  # GET /admin/categories/1.json
  def show
  end

  # GET /admin/categories/new
  def new
    @category = Category.new
  end

  # GET /admin/categories/1/edit
  def edit
  end

  # POST /admin/categories
  # POST /admin/categories.json
  def create
    # if params[:admin_category][:name].present?  
      @category = Category.new(admin_category_params)

      if @category.save
        flash[:success] ="Category was successfully created!"
        redirect_to admin_categories_path
      else
        flash[:error] = @category.errors.full_messages
        redirect_to new_admin_category_path
      end
    # else   
    #   flash[:error] ="Category name cannot be empty!"
    #   redirect_to(:controller => 'categories', :action => 'new')
    # end
  end

  # PATCH/PUT /admin/categories/1
  # PATCH/PUT /admin/categories/1.json
  def update
      if @category.update(admin_category_params)
        flash[:success] ="Category was successfully updated."
        redirect_to admin_categories_path
      else
        flash[:error] = @member.errors.full_messages
        redirect_to edit_admin_category_path
      end
  end

  # DELETE /admin/categories/1
  # DELETE /admin/categories/1.json
  def destroy
    @category.destroy
    flash[:success] ="Category was successfully destroyed."
    redirect_to admin_categories_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_category_params
      params.require(:category).permit(:name)

    end
end
