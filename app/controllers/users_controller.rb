class UsersController < ApplicationController

  before_action :get_user, only: [:show, :edit, :update]


  def show
    @projects = @user.projects.paginate(page: params[:page], per_page: 5)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Welcome to the QuickD$ide #{@user.username}, you have successfully signed up"
      redirect_to projects_path
    else
      render 'new',  status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Your account information was successfully updated"
      redirect_to user_path(@user.id)
    else
      render 'edit',  status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def get_user
    @user = User.find(params[:id])
  end

end