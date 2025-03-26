class ChatroomChannel < ApplicationCable::Channel
  def subscribed
    # chatroom = Chatroom.find(params[:id])
    stream_from "some_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
