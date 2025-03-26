import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chatroom-subscription"
export default class extends Controller {
  static targets = ["chatroom", "messages", "input"];


  connect() {
    this.chatroomId = null;
    this.userId = this.element.dataset.userId;

  }
  // getUserId() {
  //   return this.userId = document.body.dataset.userId;
  // }

  selectChatroom(event) {
    this.chatroomId = event.currentTarget.dataset.chatroomId;

    console.log(this.chatroomId)

    const url = new URL(window.location);
    url.searchParams.set("chatroom_id", this.chatroomId);
    window.history.pushState({}, "", url);

    this.loadMessages();
  }

  loadMessages() {
    fetch(`/users/${this.userId}/chatrooms/${this.chatroomId}/messages/chatroom_messages`)
      .then(response => response.json())
      .then(messages => {
        this.messagesTarget.innerHTML = messages.map(msg => `
          <div class="message ${msg.user_id == this.userId ? 'sent' : 'received'}">
            <p>${msg.content}</p>
          </div>
        `).join('');
      })
      .catch(error => console.error("Error loading messages:", error));
  }

  // sendMessage(event) {
  //   const input = event.target.closest('.chat-input').querySelector('input')
  //   const messageContent = input.value

  //   if (messageContent.trim()) {
  //     this.subscription.send({ content: messageContent })
  //     input.value = ""  // Clear the input after sending the message
  //   }
  // }

  // received(data) {
  //   // Dynamically append the new message to the chat
  //   const chatMessagesTarget = this.messagesTarget
  //   const newMessage = document.createElement('div')
  //   newMessage.classList.add('message', data.user == this.currentUser ? 'sent' : 'received')
  //   newMessage.textContent = data.content

  //   chatMessagesTarget.appendChild(newMessage)
  //   chatMessagesTarget.scrollTop = chatMessagesTarget.scrollHeight
  // }

}
