class ChatroomsController < ApplicationController
  before_action :set_user, only: [:index]

  def index
    @chatrooms = current_user.chatrooms
    @chatroom = @chatrooms.find_by(id: params[:chatroom_id])
    @message = @chatroom.messages.new if @chatroom
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
