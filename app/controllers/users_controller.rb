class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :authorize_user, only: [:edit, :update]

  after_action :verify_policy_scoped, only: [:index]

  def index
    authorize User  # This makes sure that the user is authorized to access the index
    @users = policy_scope(User)  # This applies the scope based on the user's role
  end

  def new
  end

  def create
  end

  def show
    # @user = User.find(params[:id])

    authorize @user


    @pets = @user.pets

    return unless @user.geocoded?

    @markers = [{
      lat: @user.latitude,
      lng: @user.longitude
    }]

    @provider = User.find(params[:id])
    @adopter = current_user

    # @chatrooms_to_review = Chatroom.where(user_id: @adopter.id)
    #
    # @chatrooms_to_review = Chatroom.joins(:messages).where(messages: { user_id: @adopter.id }).distinct
    #
    # Find chatrooms where both the adopter and provider have participated
    @chatrooms_to_review = Chatroom.joins(:messages)
                                    .where(messages: { user_id: [@adopter.id, @provider.id] })
                                    .group('chatrooms.id')
                                    .having('COUNT(DISTINCT messages.user_id) = 2')

    @pets_to_review = Pet.where(id: @chatrooms_to_review.pluck(:pet_id))
    # @pet_to_review = Pet.where(id: @chatrooms_to_review.pluck)

    # @pet_to_review = Pet.where(chatroom_id: @chatrooms_to_review.pluck(:id))
    # @reviews_user = Review.where(booking_id: @bookings_reviewed.pluck(:id))

  end

  def edit
    authorize @user
  end

  def update
    authorize @user
    if @user.update(user_params)
      redirect_to @user, notice: "Your profile was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end


  private

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_user
    # This makes sure that users can only edit their own profile.
    authorize @user
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :age, :location, :about_me, :photo)
  end
end
