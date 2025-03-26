class MessagesController < ApplicationController
  before_action :set_chatroom, only: [:chatroom_messages]

  def chatroom_messages
    @chatroom = Chatroom.find(params[:chatroom_id])
    @messages = @chatroom.messages.order(:created_at)

    respond_to do |format|
      format.json { render json: @messages }
    end
  end

  # def create
  #   @chatroom = Chatroom.find(params[:booking_id])
  #   @message = Message.new(message_params)
  #   @message.chatroom = @chatroom
  #   @message.user = current_user
  #   if @message.save
  #     redirect_to chatroom_path(@chatroom)
  #   else
  #     render "chatrooms/show", status: :unprocessable_entity
  #   end
  # end
  #
  #
  private

  def set_chatroom
    @chatroom = Chatroom.find(params[:chatroom_id])
  end
end
