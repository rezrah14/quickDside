def create
  @project = Project.find(params[:project_id])
  @user = User.find_by(email: params[:email]) # Assume the email address of the user to invite is provided

  if @user.present? && (current_user == @project.owner || current_user.project_users.find_by(project: @project).admin?)
    @project_user = ProjectUser.new(user: @user, project: @project, access_level: :regular) # Or another access level as needed

    if @project_user.save
      # Redirect or render a view as appropriate
    else
      # Handle errors and render a view
    end
  else
    # Handle error and render a view or redirect
  end
end
