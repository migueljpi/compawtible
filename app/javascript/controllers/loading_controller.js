import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["loadingModal"];

  connect() {
    console.log("✅ LoadingController connected");

    document.addEventListener("turbo:submit-start", () => {
      console.log("🚀 Form submitted, showing loading modal...");
      this.showLoadingModal();
    });

    document.addEventListener("turbo:frame-load", (event) => {
      if (event.target.id === "output-three") {
        console.log("✅ Data received, hiding loading modal...");
        this.hideLoadingModal();
      }
    });
  }

  showLoadingModal() {
    if (this.loadingModalTarget) {
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
    if (this.loadingModalTarget) {
      let modal = bootstrap.Modal.getInstance(this.loadingModalTarget);
      if (modal) {
        modal.hide();
      }
      setTimeout(() => {
        this.loadingModalTarget.classList.add("d-none");
      }, 300);
    }
  }
}
