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

    # Try to find an existing chatroom between the provider, adopter, and pet
    @chatroom = Chatroom.joins(:messages)
                        .where(messages: { user_id: [@provider.id, @adopter.id] })
                        .where(pet: @pet)
                        .distinct
                        .first

    # If no chatroom exists, create a new one
    unless @chatroom
      @chatroom = Chatroom.new(
        name: "Chatroom between #{@provider.first_name || 'unknown'} and #{@adopter.first_name || 'unknown'}",
        pet: @pet
      )
      @chatroom.save
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
