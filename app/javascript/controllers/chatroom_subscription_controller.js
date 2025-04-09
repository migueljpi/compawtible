import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable";

// Connects to data-controller="chatroom-subscription"
export default class extends Controller {
  static targets = ["provider", "messages", "input"];


  connect() {
    this.chatroomId = this.element.dataset.chatroomId;
    this.userId = this.element.dataset.userId;
  }

  disconnect() {
    if (this.subscription) {
      this.subscription.unsubscribe();
    }
  }

  selectChatroom(event) {
    this.chatroomId = event.currentTarget.dataset.chatroomId;

    const url = new URL(window.location);
    url.searchParams.set("chatroom_id", this.chatroomId);
    window.history.pushState({}, "", url);

    this.loadMessages();
    this.updateChatroomHeader();

    if (this.subscription) {
      this.subscription.unsubscribe();
    }

    this.subscription = createConsumer().subscriptions.create(
      {channel: "ChatroomChannel", chatroom_id: this.chatroomId},
      {received: (data) => {
        const messageElement = `
          <div class="message ${data.user_id == this.userId ? 'sent' : 'received'}">
            <p>${data.content}</p>
          </div>
        `;

        this.messagesTarget.insertAdjacentHTML("beforeend", messageElement);
        this.messagesTarget.scrollTo(0, this.messagesTarget.scrollHeight);
      }}
    )
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
    .then(() => {
      input.value = "";
      input.focus();
    })
    .catch(error => console.error("Error sending message:", error));
  }

  updateChatroomHeader() {

    fetch(`/users/${this.userId}/chatrooms/${this.chatroomId}/provider_info`)
    .then(response => {
      if (!response.ok) {
        throw new Error(`HTTP error! Status: ${response.status}`);
      }
      return response.text();
    })
    .then(text => {
      if (!text) throw new Error("Empty response from server");
      return JSON.parse(text);
    })
    .then(provider => {
      this.providerTarget.innerHTML = `
        <div class="chat-provider-info">
          <img src="${provider.image_url}" class="chatroom-avatar" alt="Provider Avatar">
            <a class="decoration-none" href="${provider.profile_url}">
              <div><h5>${provider.name}</h5></div>
            </a>
            <p> owner of </p>
            <a class="decoration-none" href="${provider.pet_url}">
              <div><h5>${provider.pet_name}</h5></div>
            </a>
        </div>
      `;
    })
    .catch(error => console.error("Error updating chatroom header:", error));
  }
}
