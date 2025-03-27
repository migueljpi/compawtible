import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chatroom-subscription"
export default class extends Controller {
  static targets = ["chatroom", "messages", "input"];


  connect() {
    this.chatroomId = null;
    this.userId = this.element.dataset.userId;

  }

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

  sendMessage(event) {
    event.preventDefault();

    if (!this.chatroomId) {
      console.error("Chatroom ID is missing!");
      return;
    }

    const input = this.inputTarget;
    const content = input.value.trim();

    if (!content) return;

    fetch(`/users/${this.userId}/chatrooms/${this.chatroomId}/messages`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
      },
      body: JSON.stringify({ message: { content: content} }),
    })
    .then(response => response.json())
    .then(data => {
      this.messagesTarget.insertAdjacentHTML("beforeend", `
        <div class="message sent"><p>${data.content}</p></div>
      `);
      input.value = "";
    })
    .catch(error => console.error("Error sending message:", error));
  }

}
