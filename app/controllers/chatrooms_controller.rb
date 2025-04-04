class ChatroomsController < ApplicationController
  before_action :set_user, only: %i[index provider_info]
  before_action :set_chatroom, only: :provider_info

  def index
    @chatrooms = policy_scope(Chatroom)
    authorize @chatrooms
    @chatrooms = current_user.chatrooms
    @chatroom = @chatrooms.find_by(id: params[:chatroom_id])
    return unless @chatroom.present?

    @message = @chatroom.messages.new
  end

  def create_chatroom
    @chatroom = policy_scope(Chatroom)
    authorize @chatroom
    @pet = Pet.find(params[:pet_id])
    @provider = @pet.provider
    @adopter = current_user

    @chatroom ||= Chatroom.create(
      name: "Chatroom between #{@provider.first_name || 'unknown'} and #{@adopter.first_name || 'unknown'}",
      pet: @pet
    )

    @chatroom.messages.find_or_create_by(user: @provider) do |msg|
      msg.content = "You have reached #{@provider.first_name}, the owner of #{@pet.name}."
    end

    @message = @chatroom.messages.create(
      content: params[:message][:content],
      user: @adopter
    )

    if @message.save
      redirect_to user_chatrooms_path(@adopter), notice: "Chatroom and message created successfully!"
    else
      flash[:error] = "Message creation failed!"
      render 'new'
    end
  end

  def provider_info
    return render json: { error: "Chatroom not found" }, status: 404 unless @chatroom

    @provider = @chatroom.users.where.not(id: current_user.id).first

    if @provider
      render json: {
        name: @provider.first_name,
        image_url: @provider.photo.attached? ? url_for(@provider.photo) : "/default_avatar.png"
      }
    else
      render json: { error: "Provider not found" }, status: 404
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_pet
    @pet = Pet.find(params[:pet_id])
  end

  def set_chatroom
    @chatroom = Chatroom.find(params[:id])
  end
end
