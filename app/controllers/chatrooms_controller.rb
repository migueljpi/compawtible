class ChatroomsController < ApplicationController
  before_action :set_user, only: [:index]

  def index
    @chatrooms = current_user.chatrooms
  end

  # def user_messages

  # end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
