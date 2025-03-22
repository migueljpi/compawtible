class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name age role location about_me photo])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: %i[first_name last_name age role location about_me photo])
  end

  def after_sign_in_path_for(resource)
    if resource.role == "provider"
      ## if want to redirect to user profile page
      return user_path(resource)
      # search_path
      # test_path
    else
      return get_search_path
      # test_path
    end
  end

end
