module ApplicationHelper
  def current_user
    User.find(session[:user_id])
    #User.find(1)
  end
end
