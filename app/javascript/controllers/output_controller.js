import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["outputThree"];

  connect() {
    console.log("OutputController connected");

    // Get the prompt ID and output attribute from the Turbo Frame data attributes
    const promptId = this.element.dataset.outputPromptId;
    const hasOutput = !!this.element.dataset.outputHasOutput; // Check if the output attribute exists

    // Listen for Turbo Frame load (triggers when Turbo replaces the frame)
    document.addEventListener("turbo:frame-load", (event) => {
      if (event.target.id === "output-three" && hasOutput) {
        console.log("Turbo Frame updated, showing output...");
        this.showOutput();
      }
    });

    // On page load, check if we should show the modal
    document.addEventListener("turbo:load", () => {
      if (promptId && hasOutput) {
        console.log("Prompt with output detected, showing output...");
        this.showOutput();
      } else {
        console.log("No prompt with output detected, keeping modal hidden.");
      }
    });
  }



  showOutput() {
    console.log("OutputController showOutput");

    if (this.hasOutputThreeTarget) {
      setTimeout(() => {
        this.outputThreeTarget.classList.remove("d-none");

        let modal = bootstrap.Modal.getInstance(this.outputThreeTarget);
        if (!modal) {
          modal = new bootstrap.Modal(this.outputThreeTarget, { backdrop: false, focus: false });
        }
        modal.show();

        console.log("Modal should be visible now");
      }, 100);
    } else {
      console.error("Output target not found!");
    }
  }

  hideOutput() {
    console.log("OutputController hideOutput");

    if (this.hasOutputThreeTarget) {
      const modal = bootstrap.Modal.getInstance(this.outputThreeTarget);
      modal.hide(); // Hide the modal

      setTimeout(() => {
        this.outputThreeTarget.classList.add("d-none"); // ADD d-none after modal is hidden
      }, 300); // Delay slightly to let Bootstrap animation complete

      localStorage.setItem("showOutput", "false"); // Store state in localStorage
    } else {
      console.error("Output target not found!");
    }
  }
}
