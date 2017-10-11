class Admin::MembersController < ApplicationController
  def index
    @members = User.all
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
    @member = User.find_by_id(params[:id])
  end

  def update

    @member = User.find_by_id(params[:id])
    if @member.update(email: params[:email])
        flash[:success] ="Success!"
      redirect_to admin_members_path(@member)
    else
      flash[:error] = @member.errors.full_messages
      redirect_to edit_admin_member_path(@member)
  end
end

  def destroy
    @member = User.find_by_id(params[:id])
    if @member.destroy
      flash[:success] ="Success!"
      redirect_to admin_members_path(@member)
    else
      flash[:error] = @member.errors.full_messages
      redirect_to admin_member_path(@member)
  end
end
end
