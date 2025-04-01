class RegistrationsController < Devise::RegistrationsController
  # After sign-up, redirect to either the user's profile or pet creation page
  def after_sign_up_path_for(resource)
    if resource.role == "provider"
      return new_user_pet_path(resource)
    else
      return get_search_path
    end
  end

  # After updating the profile, redirect to user's profile page
  def after_update_path_for(resource)
    return user_path(resource)
  end
end
