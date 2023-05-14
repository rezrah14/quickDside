class UsersController < ApplicationController

  before_action :get_user, only: [:show, :edit, :update, :destroy]
  before_action :require_user, only: [:show, :edit, :update]
  before_action :require_same_user, only: [:edit, :update, :destroy]


  def show
    @projects = @user.projects.paginate(page: params[:page], per_page: 5)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.generate_verification_token 
  
    if @user.valid?
      # Check if there is an existing user with the same email
      existing_user = User.find_by(email: @user.email)
  
      if existing_user && !existing_user.verified?
        # User already exists and hasn't been verified, send the verification email again
        UserMailer.verification_email(existing_user).deliver_now
  
        flash[:notice] = "Please check your email to verify your account."
        redirect_to root_path
      elsif @user.save
        # Send the verification email
        UserMailer.verification_email(@user).deliver_now
  
        flash[:notice] = "Please check your email to verify your account."
        redirect_to root_path
      else
        render 'new', status: :unprocessable_entity
      end
    else
      render 'new', status: :unprocessable_entity
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

  def verify_email
    @user = User.find_by(verification_token: params[:token])
  
    if @user
      @user.update(verification_token: nil)
      flash[:notice] = "Your email has been verified. You can now log in."
      redirect_to login_path
    else
      flash[:alert] = "Invalid verification token."
      redirect_to root_path
    end
  end

  def destroy
    # Logout the user
    session[:user_id] = nil
  
    # Delete the account and all associated projects
    @user.destroy
    flash[:notice] = "Account and all associated projects successfully deleted"
    redirect_to root_path
  end
  

  def join_project_new_user
    @project_invitation = ProjectInvitation.find_by(token: params[:token])
    @project = @project_invitation.project
    @user = User.new(email: @project_invitation.email)
  end

  def submit_join_project
    @project_invitation = ProjectInvitation.find_by(token: params[:token])
    @project = @project_invitation.project
    @user = User.new(params.require(:user).permit(:name, :email, :password, :password_confirmation, :verification_code))
    @user.email = @project_invitation.email
  
    if @user.save
      @project.project_users.create(user: @user, access_level: @project_invitation.access_level)
      session[:user_id] = @user.id
      flash[:notice] = "You have successfully joined the project"
      redirect_to project_path(@project)
    else
      render 'join_project_new_user'
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :first_name,
      :last_name, :phone_number)
  end

  def get_user
    @user = User.find(params[:id])
  end

  def require_same_user
    if @user != current_user
      flash[:alert] = "You can only edit or delete your own profile"
      redirect_to user_path(current_user)
    end
  end

end