import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["outputThree"];

  connect() {
    console.log("OutputController connected");
  }

  showModal() {
    console.log("Showing modal");
    this.outputThreeTarget.classList.remove("d-none");
  }

  hideModal() {
    console.log("Hiding modal");
    this.outputThreeTarget.classList.add("d-none");
  }

  testEvent() {
    console.log("turbo:submit-end event fired");
  }
}
