import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["outputThree", "loadingModal"];

  connect() {
    console.log("✅ OutputController connected");

    document.addEventListener("turbo:submit-start", () => {
      console.log("🚀 Form submitted, showing loading modal...");
      this.showLoadingModal();
    });

    document.addEventListener("turbo:frame-load", (event) => {
      if (event.target.id === "output-three") {
        console.log("✅ Data received, hiding loading modal...");
        this.hideLoadingModal();
        this.showOutput();
      }
    });
  }

  showLoadingModal() {
    if (this.hasLoadingModalTarget) {
      this.loadingModalTarget.classList.remove("d-none");

      let modal = bootstrap.Modal.getInstance(this.loadingModalTarget);
      if (!modal) {
        modal = new bootstrap.Modal(this.loadingModalTarget, { backdrop: false, keyboard: false });
      }
      modal.show();
    } else {
      console.error("❌ Loading modal not found!");
    }
  }

  hideLoadingModal() {
    if (this.hasLoadingModalTarget) {
      let modal = bootstrap.Modal.getInstance(this.loadingModalTarget);
      if (modal) {
        modal.hide();
      }
      setTimeout(() => {
        this.loadingModalTarget.classList.add("d-none");
      }, 300);
    }
  }

  showOutput() {
    console.log("🔍 Showing main output modal...");
    if (this.hasOutputThreeTarget) {
      this.outputThreeTarget.classList.remove("d-none");

      let modal = bootstrap.Modal.getInstance(this.outputThreeTarget);
      if (!modal) {
        modal = new bootstrap.Modal(this.outputThreeTarget, { backdrop: false, focus: false });
      }
      modal.show();
    } else {
      console.error("❌ Output modal not found!");
    }
  }

  hideOutput() {
    if (this.hasOutputThreeTarget) {
      let modal = bootstrap.Modal.getInstance(this.outputThreeTarget);
      if (modal) {
        modal.hide();
      }
      setTimeout(() => {
        this.outputThreeTarget.classList.add("d-none");
      }, 300);
    }
  }
}
