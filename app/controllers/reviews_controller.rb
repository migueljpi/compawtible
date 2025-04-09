class ReviewsController < ApplicationController
  # to disable pundit
  # skip_after_action :verify_policy_scoped
  # skip_after_action :verify_authorized
  #
  # to enable pudit
  after_action :verify_authorized, except: [:index]
  after_action :verify_policy_scoped, only: [:index]

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

    respond_to do |format|
      if @review.save
        @reviews_per_provider = Review.joins(chatroom: { pet: :provider }).where(users: {id: @provider.id}).order(created_at: :desc).to_a
        @reviews_per_provider_for_average = Review.joins(chatroom: { pet: :provider }).where(users: {id: @provider.id}).pluck(:provider_rating)
        @provider_average_rating = @reviews_per_provider_for_average.sum.to_f / @reviews_per_provider_for_average.count

        flash.now[:notice] = "Review was successfully created."

        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "user-reviews",
            partial: "users/review_frame",
            locals: { provider: @provider,
                      chatrooms_to_review: @chatrooms_to_review,
                      reviews_per_provider: @reviews_per_provider,
                      provider_average_rating: @provider_average_rating }
          )
        end
      else
        @reviews_per_provider = Review.joins(chatroom: { pet: :provider }).where(users: {id: @provider.id}).order(created_at: :desc).to_a
        @reviews_per_provider_for_average = Review.joins(chatroom: { pet: :provider }).where(users: {id: @provider.id}).pluck(:provider_rating)
        @provider_average_rating = @reviews_per_provider_for_average.sum.to_f / @reviews_per_provider_for_average.count
        flash.now[:alert] = @review.errors.full_messages.to_sentence

        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "user-reviews",
            partial: "users/review_frame",
            locals: { provider: @provider,
                      chatrooms_to_review: @chatrooms_to_review,
                      reviews_per_provider: @reviews_per_provider,
                      provider_average_rating: @provider_average_rating }
          )
        end
      end
    end

  end

  # work in progress
  def update
    @review = Review.find(params[:id])
    authorize @review
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
