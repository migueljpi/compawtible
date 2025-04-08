class ReviewsController < ApplicationController
  skip_after_action :verify_policy_scoped
  skip_after_action :verify_authorized
  def index
    @reviews = policy_scope(Review)

    @user = current_user
    # @user = User.find(params[:user_id])
    # @chats_reviewed = Chatrooms.where(user_id: @user.id)
    #
    # adopter can leave only for now
    @reviews_per_adopter = Review.where(user_id: @user.id)
    # @provider = review.pet.provider
  end
  def new
    Rails.logger.debug "Current User: #{current_user.inspect}"

    @review = Review.new
    authorize @review
    # raise
    @adopter = current_user
    # @provider = User.find(params[:id])
    @provider = User.find(params[:user_id])

    @chatrooms_to_review = Chatroom.joins(:messages)
                                    .where(messages: { user_id: [@adopter.id, @provider.id] })
                                    .group('chatrooms.id')
                                    .having('COUNT(DISTINCT messages.user_id) = 2')
                                    .to_a
  end

  def create
    # Rails.logger.debug "Current User: #{current_user.inspect}"
    @provider = User.find(params[:user_id])
    @adopter = current_user

    @chatroom = Chatroom.find(params[:chatroom_id])

    @chatrooms_to_review = Chatroom.joins(:messages)
                                   .where(messages: { user_id: [@adopter.id, @provider.id] })
                                   .group('chatrooms.id')
                                   .having('COUNT(DISTINCT messages.user_id) = 2')
                                   .to_a

    @review = Review.new(review_params.merge(chatroom: @chatroom, user: @adopter))
    authorize @review

    if @review.save
      flash[:notice] = "Review successfully created."
      redirect_to user_path(@provider)
    else
      flash[:danger] = "Review was not created."
      # redirect_to user_path(@provider)
      redirect_back(fallback_location: root_path)
      # render :new, status: :unprocessable_entity
    end

  end

  # work in progress
  def update
    @review = Review.find(params[:id])
    # authorize @review
    @user = User.find(params[:user_id])

    if @review.update(review_params)
      if @user.provider?
        redirect_to user_path(@user)
        flash[:notice] = "Review was successfully updated."
      else
        # index of reviews
        # redirect_to user_path(@user)
        # flash[:notice] = "Review was successfully updated."
      end
    else
        # stay wherever currently
        redirect_to user_path(@user)
        flash[:error] = "Review was not updated."
        # render :user, status: :unprocessable_entity

    end
  end
  def destroy
    @review = Review.find(params[:id])
    authorize @review
    @review.destroy
    flash[:notice] = "Review was deleted successfully."
    # stay on current page
    redirect_back(fallback_location: root_path)
  end

  private

  def review_params
    params.require(:review).permit(:provider_review_content, :provider_rating, :chatroom_id, :user_id)
  end

  def authorize_review
    # authorize @review
  end

end
