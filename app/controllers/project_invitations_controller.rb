class ProjectInvitationsController < ApplicationController
  before_action :get_project, except: [:join_project]
  before_action :require_admin_or_owner, only: [:new, :create]
  before_action :get_project_user, only: [:change_access_level]

  def new
    @invitation = ProjectInvitation.new
  end

  def create
    @invitation = ProjectInvitation.new(invitation_params)
    @invitation.inviter = current_user
    user = User.find_by(email: invitation_params["email"])
    if user.present?
      if ProjectUser.exists?(user_id: user.id, project_id: @project.id)
        flash.alert = "#{user.email} is already a member of this project."
        render 'new', status: :unprocessable_entity and return
      else
        @invitation.user_id = user.id
        @invitation.project = @project
      end
    end

    if @invitation.save
      @invitation.send_invitation_email
      flash[:notice] = "Invitation sent!"
      # Redirect the user to a page to enter their information and join the project
      redirect_to join_project_path(token: @invitation.token)
      # redirect_to project_path(@project)
    else
      flash.alert = "There was an error sending the invitation. Please try again."
      render 'new', status: :unprocessable_entity
    end
  end

  def join_project
    @project_invitation = ProjectInvitation.find_by(token: params[:token])
    @project = @project_invitation.project
    @user = User.find_by(email: @project_invitation.email)
  
    # If user doesn't exist, redirect to sign-up page with pre-populated email
    if @user.nil?
      redirect_to new_user_path(email: @project_invitation.email, invitation_token: @project_invitation.token)
      return
    end
    if ProjectUser.exists?(user_id: @user.id, project_id: @project.id)
      flash[:alert] = "You have already joined this project."
      redirect_to @project and return
    end    
    if request.get?
      # Validate verification code
      if @project_invitation.token != params[:token]
        flash[:alert] = "Invalid verification code"
        render :join_project and return
      end
      # Create new ProjectUser record
      @project_user = ProjectUser.create(user: @user, project: @project, access_level: @project_invitation.access_level)
      session[:user_id] = @user.id
      flash[:notice] = "You have been added to the project."
      redirect_to @project
    end
  end
  

  def change_access_level
    @project_user = @project.project_users.find_by(user_id: params[:id])
  
    if @project_user.owner?
      flash[:alert] = "The project owner cannot change their own access level."
    else
      @project_user.update(access_level: params[:access_level])
    end
  
    redirect_to project_path(@project)
  end

  private

  def invitation_params
    params.require(:project_invitation).permit(:email, :access_level, :first_name, :last_name)
  end

  def get_project
    @project = Project.find(params[:project_id])
  end

  def get_project_user
    @project_user = @project.project_users.find_by(user_id: params[:id])
  end

  def require_admin_or_owner
    unless @project.admins.include?(current_user) || @project.owner == current_user
      flash[:alert] = "You need admin access to invite new users to this project"
      redirect_to project_path(@project)
    end
  end
end

