class ErrorsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_after_action :verify_policy_scoped
  skip_after_action :verify_authorized


  def not_found
    render "errors/not_found", status: :not_found
  end
end
