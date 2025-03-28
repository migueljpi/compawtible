import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["outputThree"];

  connect() {
    console.log("✅ OutputController connected after navigation:", this.element);

    const promptId = this.getRailsParam("prompt_id");
      if (promptId) {
        console.log("✅ Prompt ID detected:", promptId);
        this.showOutput();
      }

    document.addEventListener("turbo:frame-load", (event) => {
      console.log("🚀 Turbo frame loaded:", event.target.id);
      if (event.target.id === "output-three") {
        console.log("showing output modal");
        this.showOutput();
      }
    });
  }

  disconnect() {
    document.removeEventListener("turbo:frame-load", this.hideOutput());
  }


  showOutput() {
    console.log("OutputThreeTarget:", this.outputThreeTarget);

    if (this.outputThreeTarget) {
      this.outputThreeTarget.classList.remove("d-none");

      let modal = bootstrap.Modal.getInstance(this.outputThreeTarget);
      if (!modal) {
        modal = new bootstrap.Modal(this.outputThreeTarget, { backdrop: false, focus: true });
        console.log("Modal instance created:", modal);
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
        //We can try to replace settimeout with this to make sure the event happens only once
        // <start>
        this.outputThreeTarget.addEventListener("hidden.bs.modal", () => { // This is triggered by finishing modal.hide()
          this.outputThreeTarget.classList.add("d-none");
      },{ once: true });
        modal.hide();
      // setTimeout(() => {
      //   this.this.outputThreeTarget.classList.add("d-none");
      // }, 300);
      }
    }
  }


  getRailsParam(name) {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(name);
  }

  disconnect() {
    console.log("❌ OutputController disconnected from:", this.element);
  }
}
