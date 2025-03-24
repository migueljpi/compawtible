import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["outputThree"];

  connect() {
    console.log("OutputController connected");
  }

  showOutput() {
    this.outputThreeTarget.classList.remove("d-none");
  }
}
