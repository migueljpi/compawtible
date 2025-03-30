import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["outputThree"];

  connect() {
    console.log("✅ OutputController connected");

    // Bind the methods to the controller instance
    this.handleFrameLoad = this.handleFrameLoad.bind(this);

    // Add the event listener
    document.addEventListener("turbo:frame-load", this.handleFrameLoad);

    const promptId = this.getRailsParam("prompt_id");
    if (promptId) {
      console.log("✅ Prompt ID detected:", promptId);
      this.showOutput();
    }
  }

  disconnect() {
    console.log("❌ OutputController disconnected");

    // Remove the event listener
    document.removeEventListener("turbo:frame-load", this.handleFrameLoad);
  }

  handleFrameLoad(event) {
    if (event.target.id === "output-three") {
      this.showOutput();
    }
  }

  showOutput() {
    if (this.outputThreeTarget) {
      this.outputThreeTarget.classList.remove("d-none");

      let modal = bootstrap.Modal.getInstance(this.outputThreeTarget);
      if (!modal) {
        modal = new bootstrap.Modal(this.outputThreeTarget, { backdrop: true, focus: true });
      }

      modal.show();

      console.log("Modal should be visible now");
    } else {
      console.error("❌ Output target not found.");
    }
  }

  hideOutput() {
    if (this.outputThreeTarget) {
      let modal = bootstrap.Modal.getInstance(this.outputThreeTarget);
      if (modal) {
        this.outputThreeTarget.addEventListener(
          "hidden.bs.modal",
          () => {
            this.outputThreeTarget.classList.add("d-none");
          },
          { once: true }
        );
        modal.hide();
      }
    }
  }

  getRailsParam(name) {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(name);
  }
}
