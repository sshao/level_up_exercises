module ApplicationHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
  
  def nav_class
    "top-bar-index" if current_page?(controller: "welcome", action: "index")
  end
end

