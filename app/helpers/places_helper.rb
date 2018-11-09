module PlacesHelper

  def check_if_admin(current_user)
    current_user.username == 'admin'
  end

end
