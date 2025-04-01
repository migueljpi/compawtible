class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  include Pundit::Authorization

  # Skip both verify_authorized and verify_policy_scoped for Devise controllers
  after_action :verify_authorized, unless: :skip_pundit?
  # after_action :verify_policy_scoped, except: :index, unless: -> { devise_controller? }
  after_action :verify_policy_scoped, except: [:index], unless: :skip_pundit?
  # after_action :verify_authorized, unless: -> { devise_controller? }
  # after_action :verify_policy_scoped, only: [:index], unless: -> { devise_controller? }

  # Skip both callbacks entirely for Devise controllers (sign-in, registration, etc.)
  skip_after_action :verify_policy_scoped, if: -> { devise_controller? }
  skip_after_action :verify_authorized, if: -> { devise_controller? }

  # Skip verify_policy_scoped specifically for the sessions controller actions
  skip_after_action :verify_policy_scoped, only: [:new, :create], if: -> { devise_controller? && controller_name == 'sessions' }



  # Skip verify_authorized and verify_policy_scoped for Devise controllers (sessions, registrations, etc.)
  after_action :verify_authorized, unless: :devise_controller?
  after_action :verify_policy_scoped, unless: :devise_controller?


  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name age role location about_me photo])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name age role location about_me photo])
  end

  def after_sign_in_path_for(resource)
    if resource.role == "provider"
      return user_path(resource)
    else
      return get_search_path
    end
  end

  private

  def skip_pundit?
    devise_controller? || (controller_name == 'pages' && action_name == 'home')
  end
end
