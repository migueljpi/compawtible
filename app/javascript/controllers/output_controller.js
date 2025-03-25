import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["outputThree"];

  connect() {
    console.log("OutputController connected");

    // Listen for Turbo Frame load (triggers when Turbo replaces the frame)
    document.addEventListener("turbo:frame-load", (event) => {
      if (event.target.id === "output-three") {
        console.log("Turbo Frame updated, showing output...");
        this.showOutput();
      }
    });
  }

  showOutput() {
    console.log("OutputController showOutput");
    if (this.hasOutputThreeTarget) {
      this.outputThreeTarget.classList.remove("d-none");
    } else {
      console.error("Output target not found!");
    }
  }

  hideOutput() {
    console.log("OutputController hideOutput");
    if (this.hasOutputThreeTarget) {
      this.outputThreeTarget.classList.add("d-none");
    } else {
      console.error("Output target not found!");
    }
  }
}
