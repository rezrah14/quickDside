module ApplicationHelper

  def gravatar_for(user, options = { size: 80})
    email_address = user.email.downcase
    hash = Digest::MD5.hexdigest(email_address)
    size = options[:size]
    gravatar_url = "https://www.gravatar.com/avatar/#{hash}?s=#{size}"
    image_tag(gravatar_url, alt: user.username, class: "rounded shadow mx-auto d-block rounded-circle")
  end

  def user_access_level(user, project)
    project_user = ProjectUser.find_by(user: user, project: project)
    project_user&.access_level
  end

  def user_verification_url(token)
    verify_email_url(token: token)
  end
  
end
