module ChatroomsHelper
  def other_user_name_from_chatroom(users)
    other_user = users.find { |user| user.first_name != current_user.first_name }
    other_user&.first_name || "Unknown User"
  end
end
