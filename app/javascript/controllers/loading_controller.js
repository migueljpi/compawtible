import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["loadingModal"];

  connect() {
    console.log(":white_check_mark: LoadingController connected");

    this.form = document.getElementById("search-form");
    console.log("This is the form:", this.form);
    this.form.addEventListener("turbo:submit-start", () => {
      console.log(":rocket: Form submitted, showing loading modal...");
      this.showLoadingModal();
    });

    document.addEventListener("turbo:frame-load", (event) => {
      if (event.target.id === "output-three") {
        console.log(":white_check_mark: Data received, hiding loading modal...");
        this.hideLoadingModal();
      }
    });
  }

  // We can remove event listeners to prevent duplicates.
  disconnect() {
    console.log(":x: LoadingController disconnected");
    document.removeEventListener("turbo:before-cache", this.cleanup);

    if (this.form) {
      this.form.removeEventListener("turbo:submit-start", this.showLoadingModal);
    }

    document.removeEventListener("turbo:frame-load", this.hideLoadingModal);
  }

  showLoadingModal() {
    console.log("Showing loading modal...");
    if (this.loadingModalTarget) {
      this.loadingModalTarget.classList.remove("d-none");

      let modal = bootstrap.Modal.getInstance(this.loadingModalTarget);
      if (!modal) {
        modal = new bootstrap.Modal(this.loadingModalTarget, { backdrop: true, keyboard: false });
      }
      modal.show();
    } else {
      console.error(":x: Loading modal not found!");
    }
  }

  hideLoadingModal() {
    if (this.loadingModalTarget) {
      let modal = bootstrap.Modal.getInstance(this.loadingModalTarget); //get bootstrap modal
      if (modal) {
        //We can try to replace settimeout with this to make sure the event happens only once
        // <start>
        this.loadingModalTarget.addEventListener("hidden.bs.modal", () => { // This is triggered by finishing modal.hide()
          this.loadingModalTarget.classList.add("d-none");
      },{ once: true });
        // <end>
        modal.hide(); //bootstrap will hide modal
      }
      // setTimeout(() => { //set timeout to allow bootstrap to finish hiding modal before adding "d-none"
      //   this.loadingModalTarget.classList.add("d-none");
      // }, 300);
    }
  }
}
