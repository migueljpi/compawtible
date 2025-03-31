class ChatroomsController < ApplicationController
  before_action :set_user, only: [:index]

  def index
    @chatrooms = current_user.chatrooms
    @chatroom = @chatrooms.find_by(id: params[:chatroom_id])
    @message = @chatroom.messages.new if @chatroom
    # @chatroom_pet = @chatroom.pet
  end

  def create_chatroom
    @pet = Pet.find(params[:pet_id])
    @provider = @pet.provider
    @adopter = current_user

    @chatroom ||= Chatroom.create(
      name: "Chatroom between #{@provider.first_name || 'unknown'} and #{@adopter.first_name || 'unknown'}",
      pet: @pet
    )

    # return redirect_to user_chatrooms_path(@adopter) unless @chatroom.save

    # end
    @chatroom.messages.find_or_create_by(user: @provider) do |msg|
      msg.content = "Hello! You have reached #{@provider.first_name}, the owner of #{@pet.name}."
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

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_pet
    @pet = Pet.find(params[:pet_id])
  end
end
