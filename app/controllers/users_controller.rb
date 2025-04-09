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

    # only works if there are messages from both adopter and provider in the chatroom
    @chatrooms_to_review = Chatroom.joins(:messages)
                                .where(messages: { user_id: [@adopter.id, @provider.id] })
                                .group('chatrooms.id')
                                .having('COUNT(DISTINCT messages.user_id) = 2')
                                .to_a

    @pets_to_review = Pet.where(id: @chatrooms_to_review.pluck(:pet_id)).to_a

    @reviews_per_provider = Review.joins(chatroom: { pet: :provider }).where(users: {id: @provider.id}).order(created_at: :desc).to_a

    @reviews_per_provider_for_average = Review.joins(chatroom: { pet: :provider }).where(users: {id: @provider.id}).pluck(:provider_rating)
    @provider_average_rating = @reviews_per_provider_for_average.sum.to_f / @reviews_per_provider_for_average.count

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
