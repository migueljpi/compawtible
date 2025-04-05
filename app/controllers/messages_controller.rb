class MessagesController < ApplicationController
  before_action :set_chatroom, only: [:chatroom_messages]

  skip_after_action :verify_policy_scoped
  skip_after_action :verify_authorized

  def chatroom_messages
    @chatroom = Chatroom.find(params[:chatroom_id])
    @messages = @chatroom.messages.order(:created_at)

    respond_to do |format|
      format.json { render json: @messages }
    end
  end

  def create # rubocop:disable Metrics/MethodLength
    @chatroom = Chatroom.find(params[:chatroom_id])
    @message = @chatroom.messages.new(message_params)
    @message.user = current_user

    if @message.save
      ChatroomChannel.broadcast_to(
        @chatroom,
        @message.as_json(only: %i[id content user_id created_at])
      )
      respond_to do |format|
        format.json { render json: @message }
      end
    else
      respond_to do |format|
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_chatroom
    @chatroom = Chatroom.find(params[:chatroom_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
