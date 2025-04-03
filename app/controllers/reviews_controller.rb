class ReviewsController < ApplicationController
  def index
    # @reviews = Review.where(chatroom_id: @user.chatrooms.pluck(:id))
    @reviews = Review.all
    @user = current_user
    # @chatrooms_reviewed = Chatroom.where(user_id: @user.id)
    # @reviews_user = Review.where(chatroom_id: @chatrooms_reviewed.pluck(:id))
  end

  def create
    # @review = Review.new(review_params)
    # @tour = Tour.find(params[:tour_id])
    # @booking.tour = @tour
    # @review.user = current_user
    # if @booking.save
    #   redirect_to user_path(current_user)
    #   flash[:notice] = "Review was successfully created."
    # else
    #   render :new, status: :unprocessable_entity
    # end


    @provider = User.find(params[:provider_id])
    @adopter = current_user

    @review = Review.new(review_params)
    # @chatroom = Chatroom.joins(:messages)
    #             .where(messages: { user_id: [@provider.id, @adopter.id] })
    #             .where(pet: @pet)
    #             .distinct
    #             .first
    @chatrooms_to_review = Chatroom.where(user_id: @user.id)



    # name: "Chatroom between #{@provider.first_name || "unknown" } and #{@adopter.first_name || "unknown" }",


    # @chatroom = Chatroom.find(params[:chatroom_id])
    # @review.chatroom = @chatroom
    # @review.chatroom.user = current_user
    # if @review.save
    #   # @review.booking.tour.update_tour_avg_rating
    #   redirect_to user_path(current_user)
    #   flash[:notice] = "Review was successfully created."
    # else
    #   render :new, status: :unprocessable_entity
    # end
  end

  def update
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    redirect_to user_path(current_user), notice: "Review deleted successfully."
  end

  private

  def review_params
    params.require(:review).permit(:provider_review_content, :provider_rating, :chatroom_id)
  end

  def set_review
    @review = Review.find(params[:id])
  end

end
