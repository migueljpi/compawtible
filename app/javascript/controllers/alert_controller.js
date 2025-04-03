import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["message"];

  connect() {
    console.log("✅ Alert controller connected. Found alerts:", this.messageTargets.length);
    console.log("Alert controller connected");

    this.messageTargets.forEach((alert) => {
      setTimeout(() => {
        this.dismiss(alert);
      }, 5000);
    });
  }

  dismiss(event) {
    console.log("Dismiss alert triggered");
    let alert;

    if (event instanceof Event) {
      // Button click event - find the closest alert div
      alert = event.target.closest(".alert");
    } else {
      // Timeout dismissing - directly use the passed alert
      alert = event;
    }

    if (alert) {
      console.log("Dismissing alert");
      alert.classList.add("fade-out");
      setTimeout(() => {
        alert.remove();
      }, 500);
    }
  }
}
