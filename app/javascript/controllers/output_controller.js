import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["outputThree"];

  connect() {

    const promptId = this.getRailsParam("prompt_id");
      if (promptId) {
        console.log("✅ Prompt ID detected:", promptId);
        this.showOutput();
      }

    document.addEventListener("turbo:frame-load", (event) => {
      if (event.target.id === "output-three") {
        this.showOutput();
      }
    });
  }

  disconnect() {
    document.removeEventListener("turbo:frame-load", this.hideOutput());
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
