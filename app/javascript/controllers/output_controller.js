import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["outputThree"];

  connect() {
    console.log("OutputController connected");

    // Get the prompt ID from the Turbo Frame data attribute
    const promptId = this.element.dataset.outputPromptId;

    // Listen for Turbo Frame load (triggers when Turbo replaces the frame)
    document.addEventListener("turbo:frame-load", (event) => {
      if (event.target.id === "output-three") {
        console.log("Turbo Frame updated, showing output...");
        this.showOutput();
      }
    });

    // On page load, check if we should show the div
    document.addEventListener("turbo:load", () => {
      const shouldShow = localStorage.getItem("showOutput");

      if (shouldShow === "true" || promptId) {
        this.showOutput();
      }
    });
  }

  showOutput() {
    console.log("OutputController showOutput");
    if (this.hasOutputThreeTarget) {
      this.outputThreeTarget.classList.remove("d-none");  // Remove d-none to show the partial
      localStorage.setItem("showOutput", "true"); // Store state in localStorage
    } else {
      console.error("Output target not found!");
    }
  }

  hideOutput() {
    console.log("OutputController hideOutput");
    if (this.hasOutputThreeTarget) {
      this.outputThreeTarget.classList.add("d-none");  // Add d-none to hide the partial
      localStorage.setItem("showOutput", "false"); // Store state in localStorage
    } else {
      console.error("Output target not found!");
    }
  }
}
