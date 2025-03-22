class RegistrationsController < Devise::RegistrationsController

def after_sign_up_path_for(resource)
  ## default
  # after_sign_in_path_for(resource) if is_navigational_format?
  if resource.role == "provider"
    ## if want to redirect to user profile page
    # user_path(resource)
    return new_user_pet_path(resource)
    # search_path
    # test_path
  else
    return get_search_path
    # test_path
  end
end

#
def after_update_path_for(resource)
  ## default
  # sign_in_after_change_password? ? signed_in_root_path(resource) : new_session_path(resource_name)
  return user_path(resource)
end

end
