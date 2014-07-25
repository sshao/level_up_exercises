module UserHelper
  def name(user)
    user.username || user.email
  end
  
  def user_area(&block)
    yield if user_signed_in?
  end

  def guest_area(&block)
    yield unless user_signed_in?
  end
end

